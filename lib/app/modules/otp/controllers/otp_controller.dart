import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class OtpController extends GetxController {
  TextEditingController otpCtrl = TextEditingController();
  RxString otpErrorMessage=''.obs;
  var verifyLoading = false.obs;

  Future<void> sendOtp(bool? isResetPass) async {
    Map<String,String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      verifyLoading.value=true;
      var body = {
        // 'email': Get.arguments['email'].toString(),
        // 'otp':otpCtrl.text,
        // 'token': Get.arguments['verificationToken'].toString()
      };
      var response = await http.post(Uri.parse(ApiConstants.verifyEmailWithOtpUrl), body:  jsonEncode(body),headers: headers);
      final responseData = jsonDecode( response.body);
      if (response.statusCode == 200) {
        Get.snackbar(responseData['message'], '');
        String accessToken = responseData['data']['attributes']['result']['tokens']['accessToken'];
        String userRole = responseData['data']['attributes']['result']['user']['role'];
        await PrefsHelper.setString('userRole', userRole);
        String role = await PrefsHelper.getString('userRole');
         await PrefsHelper.setString('token', accessToken);
        String token = await PrefsHelper.getString('token');
        print(token);
        print(role);
        if(isResetPass==true){
          // Get.toNamed(Routes.CHANGE_PASSWORD,arguments: {'email': Get.arguments['email']});
        }else{
         // Get.toNamed(Routes.HOME);
        }

      } else {
        print('Error>>>');
        print('Error>>>${response.body}');
        otpErrorMessage.value = responseData['message'];
        Get.snackbar(otpErrorMessage.value.toString(), '');
      }
    }  on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'No internet connection. Please check your network and try again.',
        snackPosition: SnackPosition.TOP,
      );
    }catch(e){
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        snackPosition: SnackPosition.TOP,
      );
      print(e);
    }finally{
      verifyLoading.value=false;
    }
  }
  @override
  void onClose() {
    otpCtrl.dispose();
    super.onClose();
  }
}
