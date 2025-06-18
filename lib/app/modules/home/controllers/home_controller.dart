import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class HomeController extends GetxController {

  TextEditingController searchCtrl = TextEditingController();
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  var isLoading = false.obs;

  Future<void> fetchMechanic({String? queryService}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.searchMechanicUrl(queryService??''),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {

        String message = response.data!['message'];
        final responseData = response.data!['data'] as List<dynamic>;
        print(responseData);

      } else {
        Get.snackbar('Failed', response.message ?? 'Resend otp failed');
      }
    } catch (e) {
      print(e);
      throw NetworkException('$e');
    } finally {
      isLoading.value = false;
    }

  }
  @override
  void onClose() {
    searchCtrl.clear();
    super.onClose();
  }
}
