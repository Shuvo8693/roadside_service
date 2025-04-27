import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  //ProfileAttributes profileAttributes = ProfileAttributes();
  RxBool verifyLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> login() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var body = {'email': emailCtrl.text.trim(), 'password': passCtrl.text};

    try {
      verifyLoading.value= true;



    } on Exception catch (e) {
      errorMessage.value= 'Something went wrong';
    }finally{
      verifyLoading.value= false;
    }

  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }
}
