import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/model/order_status_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/favourite_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_details_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MechanicOrderController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<OrderStatusModel> orderStatusModel = OrderStatusModel().obs;
  var isLoading = false.obs;


  Future<void> fetchStatus(String status) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.orderStatusUrl(status),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String, dynamic>? responseData = response.data;
        print(responseData);
        orderStatusModel.value = OrderStatusModel.fromJson(responseData ?? {});
        print(orderStatusModel.value);
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

  ///====================== Mechanic Accept order =======================

  RxMap<int,bool> isLoading2 = <int,bool>{}.obs;

  Future<void> acceptOrder(String orderId,int index) async {
    String token = await PrefsHelper.getString('token');


    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2[index] = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.mechanicAcceptOrderUrl(orderId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data!['message'];
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
      isLoading2[index] = false;
    }
  }

  ///====================== Mechanic Favourite ==============================

  RxMap<int,bool> isLoading3 = <int,bool>{}.obs;

  Future<void> cancelOrder(String orderId, int index) async {
    String token = await PrefsHelper.getString('token');


    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading3[index] = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.mechanicCancelOrderUrl(orderId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data!['message'];
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
      isLoading3[index] = false;
    }
  }

  ///====================== Mark as complete ==============================


  RxMap<int,bool> isLoading4 = <int,bool>{}.obs;

  Future<void> markAsComplete(String orderId, int index) async {
    String token = await PrefsHelper.getString('token');


    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading4[index] = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.mechanicMarkAsCompleteUrl(orderId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data!['message'];
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
      isLoading4[index] = false;
    }
  }


}
