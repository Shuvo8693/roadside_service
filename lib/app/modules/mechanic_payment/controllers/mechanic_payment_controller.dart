import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/model/order_status_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_payment/model/payment_status_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MechanicPaymentController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<PaymentStatusResponse> paymentStatusModel = PaymentStatusResponse().obs;
  var isLoading = false.obs;


  Future<void> fetchPaymentStatus() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.mechanicPaymentStatusUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String, dynamic>? responseData = response.data;
        print(responseData);
        paymentStatusModel.value = PaymentStatusResponse.fromJson(responseData ?? {});
        print(paymentStatusModel.value);
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

  /// ================== withdraw request ==================

  Future<void> withdrawRequest(double amount,VoidCallback callBack) async {
    String token = await PrefsHelper.getString('token');

    final body ={
      "amount" : amount
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.withdrawRequestUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data!['message'];
        callBack();
         //Get.snackbar('Successfully', responseMessage);
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

}
