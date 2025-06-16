
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class OtpController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  TextEditingController otpCtrl = TextEditingController();
  RxString otpErrorMessage=''.obs;
  var isLoading = false.obs;

  Future<void> sendOtp(bool? isResetPass) async {
     String token = await PrefsHelper.getString('token');
     String userMail = Get.arguments['email'] ?? '';
    final body = {
      "otp": otpCtrl.text.trim(),
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: isResetPass==true? ApiConstants.verifyForgotOtpUrl(userMail) : ApiConstants.verifyOtpUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String userRole = response.data!['data']['role'];
          await PrefsHelper.setString('role', userRole);
       String role = await PrefsHelper.getString('role');
       String token = await PrefsHelper.getString('token');
       print('role: $role , token : $token');
        if(isResetPass==true){
          Get.toNamed(Routes.CHANGE_PASSWORD);
        }else{
          if(role =='user'){
            Get.toNamed(Routes.HOME);
          } else if(role =='mechanic'){
            Get.toNamed(Routes.MECHANIC_HOME);
          }else{
            Get.snackbar('Failed route', ' Select your role before route home');
          }
        }

      } else {
        Get.snackbar('Failed', response.message ?? 'User verify failed ');
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
    otpCtrl.dispose();
    super.onClose();
  }
}
