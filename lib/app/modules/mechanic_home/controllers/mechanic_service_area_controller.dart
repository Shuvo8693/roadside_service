import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';


class MechanicServiceAreaController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  RxBool isLoading = false.obs;

  Future<void> selectServiceArea({LatLng? latLng , double? distanceRadius}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    Map<String,dynamic> body = {
      "latitude": latLng?.latitude,
      "longitude": latLng?.longitude,
      "serviceRadius": distanceRadius
    };

    try {
      isLoading.value =true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.serviceAreaUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Get.snackbar('Successfully', response.message ?? 'Service area selected');
      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to inactive status');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    }finally{
      isLoading.value = false;
    }
  }
}
