import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MyLocationSelectionController extends GetxController {
  LatLng? latLng;
  final TextEditingController pickupLocationCtrl = TextEditingController();
  final _pickedNewLocation = Rxn<LatLng?>();
  set pickedNewLocation(LatLng? value) => _pickedNewLocation.value = value;
  LatLng? get pickedNewLocation => _pickedNewLocation.value;

  Future<void> goToSearchLocationMark(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        var latLngLocation = LatLng(location.latitude, location.longitude);
        latLng = latLngLocation;
        print(latLng);
      }
    } catch (e) {
      print('Error occurred while searching: $e');
    }
  }

  ///================= Set location ====================

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  var isLoading = false.obs;


  Future<void> setLocation({LatLng? latLng,Function(String message)? callBack}) async {
    String token = await PrefsHelper.getString('token');
    final body ={
      "lat": latLng?.latitude,
      "lng": latLng?.longitude
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.setLocationUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data?['message'];
        callBack?.call(responseMessage);

      } else {
        if (kDebugMode) {
          print(response.message);
        }
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

}
