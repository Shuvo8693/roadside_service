import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class SignInController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> signIn() async {

    final body = {
      "email": emailCtrl.text.trim(),
      "password": passCtrl.text.trim()
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.logInUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String token = response.data!['data']['token'];
        String role = response.data!['data']['user']['role'];
        print('role: $role , token : $token');
        await PrefsHelper.setString('role', role);
        await PrefsHelper.setString('token', token).then((value)async{
          String? userRole =await PrefsHelper.getString('role');
          if(userRole =='user'){
            Get.toNamed(Routes.HOME);
          } else if(userRole =='mechanic'){
            Get.toNamed(Routes.MECHANIC_HOME);
          }else{
            Get.snackbar('Failed to route', ' Login again or create account');
          }
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
    passCtrl.dispose();
    super.onClose();
  }
}
