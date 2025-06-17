import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class ChangePasswordController extends GetxController {
  TextEditingController oldPassCtrl = TextEditingController();
  TextEditingController newPassCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  var isLoading = false.obs;

  Future<void> resetPassword({bool isResetPass = false, Function( String)? responseMessage}) async {
    String token = await PrefsHelper.getString('token');
    var body = {
     if(isResetPass==false) "oldPassword": oldPassCtrl.text.trim(),
      "newPassword": newPassCtrl.text.trim(),
      "confirmPassword": confirmPassCtrl.text.trim()
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: isResetPass?ApiConstants.resetPasswordUrl : ApiConstants.changePasswordUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String message = response.data!['message'];
        if(isResetPass){
          Get.offAndToNamed(Routes.SIGN_IN);
        }else{
          responseMessage!(message);
          Get.snackbar('Success', message);
        }
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
    newPassCtrl.clear();
    confirmPassCtrl.clear();
    super.onClose();
  }
}
