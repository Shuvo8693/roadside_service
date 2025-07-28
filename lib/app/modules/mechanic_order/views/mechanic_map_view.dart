import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:roadside_assistance/app/modules/my_booking/controllers/order_tracking_controller.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/sk_key.dart';

class MechanicMapView extends StatefulWidget {
  const MechanicMapView({super.key});

  @override
  _OrderMechanicMapState createState() => _OrderMechanicMapState();
}

class _OrderMechanicMapState extends State<MechanicMapView> {
  final OrderTrackingController _orderTrackingController = Get.put(OrderTrackingController(),tag: 'Mechanic');


  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _orderTrackingController.polylinePoints = PolylinePoints(apiKey: SKey.googleApiKey);
      // First initialize tracking to get initial data
      await _orderTrackingController.initializeTracking();
      // Then initialize socket for real-time updates
      _orderTrackingController.initSocket();

      print('App initialization completed');
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  @override
  void dispose() {
    _orderTrackingController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
        ),
      ),
      body: Stack(
        children: [
          // Map layer with proper reactive updates
          Obx(() {
            // Get current locations from controller
            LatLng userLocation = _orderTrackingController.pickupLocation.value;
            LatLng driverLocation = _orderTrackingController.driverLocation.value;

            // Create markers set
            Set<Marker> markers = _buildMarkers(userLocation, driverLocation);

            // Create polylines set
            Set<Polyline> polylines = _buildPolylines();

            // Show loading indicator if locations are not available
            if (userLocation.latitude == 0 && userLocation.longitude == 0) {
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.h),
                      Text('Loading map...'),
                    ],
                  ),
                ),
              );
            }

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation,
                zoom: 15,
              ),
              mapType: MapType.hybrid,
              polylines: polylines,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _orderTrackingController.setMapController(controller);
                print('Map created with controller');
              },
              padding: EdgeInsets.only(bottom: 150.h),
              myLocationEnabled: false, // Disable default location button
              compassEnabled: true,
              mapToolbarEnabled: false,
            );
          }),

          // Connection status indicator
          Obx(() => _orderTrackingController.connectionStatus.value != 'Connected'
              ? Positioned(
            top: 100.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    'Status: ${_orderTrackingController.connectionStatus.value}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
           ):SizedBox.shrink(),
          ),
          // Debug info (remove in production)
          if (kDebugMode)
            Positioned(
              top: 170.h,
              right: 16.w,
              child: Obx(() => Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location Info:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('User: ${_orderTrackingController.pickupLocation.value}', style: TextStyle(color: Colors.white, fontSize: 8.sp)),
                    Text('Driver: ${_orderTrackingController.driverLocation.value}', style: TextStyle(color: Colors.white, fontSize: 8.sp)),
                    Text('Polyline: ${_orderTrackingController.polylineCoordinates.length} points', style: TextStyle(color: Colors.white, fontSize: 8.sp)),
                  ],
                ),
              )),
            ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers(LatLng userLocation, LatLng driverLocation) {
    Set<Marker> markers = {};

    // Add user location marker
    if (userLocation.latitude != 0 && userLocation.longitude != 0) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: userLocation,
          infoWindow: InfoWindow(
              title: 'Your Location',
              snippet: 'Pickup point'
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add driver location marker
    if (driverLocation.latitude != 0 && driverLocation.longitude != 0) {
      markers.add(
        Marker(
          markerId: MarkerId('driver'),
          position: driverLocation,
          infoWindow: InfoWindow(
              title: 'Mechanic',
              snippet: 'Current location'
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_orderTrackingController.polylineCoordinates.isEmpty) {
      return {};
    }

    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: _orderTrackingController.polylineCoordinates,
        color: AppColors.primaryColor,
        width: 4,
        patterns: [PatternItem.dot, PatternItem.gap(10)],
      )
    };
  }

  void _refreshLocation() async {
    try {
      await _orderTrackingController.fetchRoutePolyline();
      Get.snackbar(
        'Success',
        'Location refreshed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh location',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

}