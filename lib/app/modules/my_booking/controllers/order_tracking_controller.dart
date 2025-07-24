import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/data/current_location_service.dart';
import 'package:roadside_assistance/sk_key.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/my_booking/model/order_tracking_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class OrderTrackingController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<TrackingModel> trackingModel = TrackingModel().obs;
  var isLoading = false.obs;

  Future<void> initializeTracking() async {
    String token = await PrefsHelper.getString('token');
    String mechanicId = Get.arguments['mechanicId']??'';
    String orderId = Get.arguments['orderId']??'';

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());
      Position position = await LocationService.getCurrentLocation();

    final body ={
      "orderId" : orderId,
      "coordinates" : [position.longitude, position.latitude]
    };

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.orderTrackingInitializeUrl(mechanicId),
        timeout: Duration(seconds: 10),
        body: body,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data?['data'];
        trackingModel.value = TrackingModel.fromJson(responseData ?? {});
        print('Initial tracking model: ${trackingModel.value}');

        // Initialize map after getting initial data
        await fetchRoutePolyline();
      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to fetch booking');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    } finally {
      isLoading.value = false;
    }
  }

  ///==================== socket ================

  IO.Socket? socket;
  Timer? locationTimer;

  var isConnected = false.obs;
  var connectionStatus = 'Disconnected'.obs;

  void initSocket() async{
    String token = await PrefsHelper.getString('token');
    try {
      Map<String, dynamic> options = {
        'transports': ['websocket'],
        'autoConnect': false,
      };

      // Add token to headers if provided
      if (token.isNotEmpty) {
        options['extraHeaders'] = {
          'token': token,
        };
      }

      socket = IO.io('https://radwan5000.sobhoy.com', options);

      setupSocketListeners(); // Setup listeners before connecting
      socket?.connect();

    } catch (e) {
      print('Socket connection error: $e');
      connectionStatus.value = 'Connection Failed';
    }
  }

  void setupSocketListeners() {
    // Clear existing listeners to prevent duplicates
    socket?.clearListeners();
    socket?.off('connect');
    socket?.off('disconnect');
    socket?.off('connect_error');
    socket?.off('updateLocation');

    // Connection events
    socket?.on('connect', (_) {
      print('Connected to socket server');
      isConnected.value = true;
      connectionStatus.value = 'Connected';

      startLocationTracking(); // Emit Location < ================
    });

    socket?.on('disconnect', (_) {
      print('Disconnected from socket server');
      isConnected.value = false;
      connectionStatus.value = 'Disconnected';
      // Stop location tracking when disconnected
      locationTimer?.cancel();
    });

    socket?.on('connect_error', (error) {
      print('Connection error: $error');
      connectionStatus.value = 'Connection Error';
    });

    // Listen for location updates from other users/mechanics
    socket?.on('updateLocation', (data) {
      handleLocationUpdate(data);
    });
  }

  ///============ start location tracking =================

  void startLocationTracking() {
    String mechanicId = Get.arguments['mechanicId']??'';
    String orderId = Get.arguments['orderId']??'';

    // Cancel existing timer if any
    locationTimer?.cancel();

    locationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        // Get current location
        Position position = await LocationService.getCurrentLocation();
        print('Current position: ${position.latitude}, ${position.longitude}');
        // Send location update
        sendLocationUpdate(
          orderId: orderId,
          userId: mechanicId,
          userType: 'user',
          latitude: position.latitude,
          longitude: position.longitude,
        );

      } catch (e) {
        print('Error getting location: $e');
      }
    });
  }

  void handleLocationUpdate(dynamic data) {
    try {
      print('Received location update: $data');

      if (data != null && data is Map<String, dynamic>) {
        // Parse the entire response using your TrackingModel
        TrackingModel newTrackingModel = TrackingModel.fromJson(data);
        trackingModel.value = newTrackingModel;

        print('Parsed tracking data: ${trackingModel.value.status}');
        print('User location coordinates: ${trackingModel.value.userLocation?.coordinates}');
        print('Mechanic location coordinates: ${trackingModel.value.mechanicLocation?.coordinates}');

        // Update the map and polyline when new location data is received
        fetchRoutePolyline();
        update();
      }
    } catch (e) {
      print('Error handling location update: $e');
    }
  }

  // Send location update to server
  void sendLocationUpdate({
    required String orderId,
    required String userId,
    required String userType,
    required double latitude,
    required double longitude,
  }) {
    if (socket?.connected == true) {
      Map<String, dynamic> locationData = {
        'orderId': orderId,
        'userId': userId,
        'userType': userType,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };

      socket?.emit('updateLocation', locationData);
      print('Sent location update: $locationData');
    } else {
      print('Socket not connected, cannot send location update');
    }
  }

  // Reconnect with token
  void reconnectWithToken() {
    locationTimer?.cancel();
    socket?.disconnect();
    initSocket();
  }


  @override
  void onClose() {
    locationTimer?.cancel();
    socket?.disconnect();
    socket?.dispose();
    super.onClose();
  }

  ///===========================Map & Polyline ====================

  GoogleMapController? mapController;

  Rx<LatLng> pickupLocation = LatLng(0, -0).obs;
  Rx<LatLng> driverLocation = LatLng(0, -0).obs;

  final RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  late PolylinePoints polylinePoints;

  Future<void> fetchRoutePolyline() async {
    try {
      polylinePoints = PolylinePoints(apiKey: SKey.googleApiKey);

      LocationData? userLocationData = trackingModel.value.userLocation;
      LocationData? mechLocationData = trackingModel.value.mechanicLocation;

      // Check if both locations are available
      if (userLocationData?.coordinates == null ||
          userLocationData!.coordinates!.length < 2 ||
          mechLocationData?.coordinates == null ||
          mechLocationData!.coordinates!.length < 2) {
        print('Insufficient location data for polyline');
        return;
      }

      // FIXED: Correct coordinate assignment
      // Assuming coordinates array is [longitude, latitude] (GeoJSON format)
      double userLat = userLocationData.coordinates![1];
      double userLng = userLocationData.coordinates![0];
      double mechLat = mechLocationData.coordinates![1];
      double mechLng = mechLocationData.coordinates![0];

      // Validate coordinates
      if (!_isValidCoordinate(userLat, userLng) || !_isValidCoordinate(mechLat, mechLng)) {
        print('Invalid coordinates detected');
        return;
      }

      pickupLocation.value = LatLng(userLat, userLng);
      driverLocation.value = LatLng(mechLat, mechLng);

      print('User location: ${pickupLocation.value}');
      print('Mechanic location: ${driverLocation.value}');

      // Calculate bounds
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
            pickupLocation.value.latitude < driverLocation.value.latitude
                ? pickupLocation.value.latitude
                : driverLocation.value.latitude,
            pickupLocation.value.longitude < driverLocation.value.longitude
                ? pickupLocation.value.longitude
                : driverLocation.value.longitude
        ),
        northeast: LatLng(
            pickupLocation.value.latitude > driverLocation.value.latitude
                ? pickupLocation.value.latitude
                : driverLocation.value.latitude,
            pickupLocation.value.longitude > driverLocation.value.longitude
                ? pickupLocation.value.longitude
                : driverLocation.value.longitude
        ),
      );

      // Animate camera to show both locations
      if (mapController != null) {
        await mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 100.0)
        );
      }

      // Get polyline between locations
      RoutesApiRequest request = RoutesApiRequest(
          origin: PointLatLng(driverLocation.value.latitude, driverLocation.value.longitude),
          destination: PointLatLng(pickupLocation.value.latitude, pickupLocation.value.longitude),
          travelMode: TravelMode.driving,
          routingPreference: RoutingPreference.trafficAware
      );

      RoutesApiResponse response = await polylinePoints.getRouteBetweenCoordinatesV2(request: request);

      if (response.routes.isNotEmpty) {
        final route = response.routes.first;
        double? distance = route.distanceKm;
        double? duration = route.durationMinutes;
        List<PointLatLng> points = route.polylinePoints ?? [];

        polylineCoordinates.clear();
        for (var point in points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        print('Polyline points count: ${polylineCoordinates.length}');
        print('Distance: ${distance}km, Duration: ${duration}min');

        update();
      } else {
        print("No polyline points received. Routes: ${response.routes}");
      }

    } catch (e) {
      print('Error fetching route polyline: $e');
    }
  }

  // Helper method to validate coordinates
  bool _isValidCoordinate(double lat, double lng) {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180 &&
        lat != 0.0 && lng != 0.0; // Assuming 0,0 is invalid for your use case
  }

  // Method to set map controller
  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

}