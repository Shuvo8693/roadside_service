import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/model/order_details_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/model/order_status_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';


class OrderDetailsController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<OrderDetailResponse> orderDetailResponse = OrderDetailResponse().obs;
  var isLoading = false.obs;


  Future<void> fetchOrderDetails() async {
    String token = await PrefsHelper.getString('token');
      String orderId = Get.arguments['orderId']??'';

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.orderDetailsUrl(orderId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String, dynamic>? responseData = response.data;
        print(responseData);
        orderDetailResponse.value = OrderDetailResponse.fromJson(responseData ?? {});
        print(orderDetailResponse.value);
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