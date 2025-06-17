import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class ForgotPasswordController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  TextEditingController emailCtrl = TextEditingController();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> sendMail({bool? isResetPass}) async {

    final body = {
      "email": emailCtrl.text.trim(),
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.emailSendUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String token = response.data!['data']['token'];
        String role = response.data!['data']['role'];
        print(" token : $token , role : $role");
        await PrefsHelper.setString('role', role);
        await PrefsHelper.setString('token', token).then((value)async{
          Get.toNamed(
            Routes.OTP,
            arguments: {
              'email': emailCtrl.text,
              'isResetPass': isResetPass ?? false,
            },
          );
        });
      } else {
        Get.snackbar('Failed', response.message ?? 'User login failed ');
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
    emailCtrl.dispose();
    super.onClose();
  }
}


