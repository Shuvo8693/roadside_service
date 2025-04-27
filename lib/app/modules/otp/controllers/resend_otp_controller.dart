import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roadside_assistance/app/data/api_constants.dart';

class ResendOtpController extends GetxController {

  var isLoading = false.obs;

  Future<void> reSendMail(bool? isResetPass) async {


    if (isLoading.value) {
      return; // Prevent multiple taps
    }

    isLoading.value = true;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
     // 'email': Get.arguments['email'].toString(),
    };

    try {

      final url = Uri.parse(ApiConstants.resendOtpUrl);
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = jsonEncode(body);

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('Response Data: $responseData');
        Get.snackbar('Otp Resend', responseData['message']);
      } else {
        print('Error: ${response.statusCode}, Message: ${response.body}');
      }
    } on SocketException catch (_) {
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
    } finally {
      isLoading.value = false;
    }
  }


}
