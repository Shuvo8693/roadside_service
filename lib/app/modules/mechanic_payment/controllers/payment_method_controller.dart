import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/model/payment_method_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class PaymentMethodController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<PaymentMethodsResponse> paymentMethodResponse = PaymentMethodsResponse().obs;
  var isLoading = false.obs;


  Future<void> fetchPaymentMethod() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.paymentMethodUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String, dynamic>? responseData = response.data;
        print(responseData);
        paymentMethodResponse.value = PaymentMethodsResponse.fromJson(responseData ?? {});
        print(paymentMethodResponse.value);
      } else {
        if (kDebugMode) {
          print(response.message);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ================== Add payment method ==================
  var isLoading2 = false.obs;

  Future<void> addPaymentMethod({PaymentBody? paymentBody}) async {
    String token = await PrefsHelper.getString('token');

    final body ={
      "bankName" : paymentBody?.bankName,
      "accountHolderName" : paymentBody?.accountHolderName,
      "accountNumber" : paymentBody?.accountNumber
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.paymentMethodCreationUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data!['message'];
        await fetchPaymentMethod();
        Get.snackbar('Successfully', responseMessage);
      } else {
        if (kDebugMode) {
          print(response.message);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    } finally {
      isLoading2.value = false;
    }
  }

}

class PaymentBody{
   String? bankName;
   String? accountHolderName;
   String? accountNumber;

   PaymentBody(this.bankName,this.accountHolderName,this.accountNumber);
}
