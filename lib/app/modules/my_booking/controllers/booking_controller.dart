import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/my_booking/model/order_booking_response_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MyBookingController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<OrdersResponse> orderResponseModel = OrdersResponse().obs;
  var isLoading = false.obs;

  Future<void> fetchBookings() async {
    String token = await PrefsHelper.getString('token');
   // _networkCaller.clearInterceptors();
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.bookedOrdersUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        print(responseData);
        orderResponseModel.value = OrdersResponse.fromJson(responseData ?? {});
        print(orderResponseModel.value);
      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to fetch booking');
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


  RxMap<int,bool> isLoading2 = <int,bool>{}.obs;
  Future<void> makePayment({int? index,String? orderId,VoidCallback? callBack}) async {
    String token = await PrefsHelper.getString('token');
     final body ={
       "transactionId" : UniqueKey().toString()
     };
    _networkCaller.clearInterceptors();
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2[index!] = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.makePaymentUrl(orderId??''),
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data?['message'];
        callBack?.call();
        Get.snackbar('Success', responseMessage);
      } else {
        if(!Get.isSnackbarOpen){
          Get.snackbar('Failed', response.message ?? 'Failed to fetch booking');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    } finally {
      isLoading2[index!] = false;
    }
  }

}
