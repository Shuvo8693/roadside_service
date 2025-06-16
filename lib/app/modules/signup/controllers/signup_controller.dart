import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class SignupController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  RxBool isLoading = false.obs;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  createUser() async {
      String role = Get.arguments['role'];
    final body = {
      "name": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "role": role,
      "password": passwordController.text.trim(),
      "confirmPassword": passwordController.text.trim(),
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.registerUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Get.snackbar('Success', response.message ?? 'User creation successfully done ',);
         String token = response.data!['data']['token'];
         String role = response.data!['data']['role'];
          await PrefsHelper.setString('role', role);
          await PrefsHelper.setString('token', token).then((value){
           Get.toNamed(Routes.OTP);
         });

      } else {
        Get.snackbar('Failed', response.message ?? 'User creation failed ');
        //throw NetworkException(response.message ?? 'User creation failed ');
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
