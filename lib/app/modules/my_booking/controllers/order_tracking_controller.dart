import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/my_booking/model/order_booking_response_model.dart';
import 'package:roadside_assistance/app/modules/my_booking/model/order_tracking_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class OrderTrackingController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<TrackingModel> orderTrackingModel = TrackingModel().obs;
  var isLoading = false.obs;

  Future<void> initializeTracking() async {
    String token = await PrefsHelper.getString('token');
   String mechanicId = Get.arguments['mechanicId']??'';
   String orderId = Get.arguments['orderId']??'';

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    final body ={
        "orderId" : orderId
    };

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.orderTrackingInitializeUrl(mechanicId),
        timeout: Duration(seconds: 10),
        body: body,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data?['data'];
        orderTrackingModel.value = TrackingModel.fromJson(responseData ?? {});
        print(orderTrackingModel.value);
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
}
