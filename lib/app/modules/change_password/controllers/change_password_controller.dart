import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roadside_assistance/app/data/api_constants.dart';

class ChangePasswordController extends GetxController {
  TextEditingController newPassCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();


  Future<void> resetPassword() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    String email= Get.arguments['email'];
    var body = {
      'email':email ,
      'password': confirmPassCtrl.text
    };

    var response = await http.post(Uri.parse(ApiConstants.resetPasswordUrl), body:  jsonEncode(body),headers: headers);
    final responseData = jsonDecode( response.body);
    if (response.statusCode == 200) {
      print(responseData.toString());
    } else {
      print('Error>>>');
      print('Error>>>${response.body}');
    }
  }

 /* @override
  void onClose() {
    newPassCtrl.clear();
    confirmPassCtrl.clear();
    super.onClose();
  }*/
}
