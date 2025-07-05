import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MechanicHomeController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
   RxBool isAvailability = false.obs;

  Future<void> changeAvailability({String? mechanicId}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.toggleAvailabilityUrl(mechanicId??''),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final isAvailable = response.data!['data']['isAvailable'] ;
        print(isAvailable);
        isAvailability.value = isAvailable;
        Get.snackbar('Successfully', response.message ?? 'Changed status');
      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to inactive status');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    }
  }

  /// Get Availability

  Future<void> fetchAvailability() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.mechanicAvailabilityUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final isAvailable = response.data!['data'];
        print(isAvailable);
        isAvailability.value = isAvailable;
      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to inactive status');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    }
  }
}
