import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/check_out/model/mechanic_service_price_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class CheckOutController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<MechanicServicePriceModel> mechanicServicePriceModel = MechanicServicePriceModel().obs;
  var isLoading = false.obs;

  Future<void> fetchMechanicServiceWithPrice() async {
    String token = await PrefsHelper.getString('token');
   String mechanicId = Get.arguments['mechanicId'] ?? '';

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.mechanicServiceWithPriceUrl(mechanicId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        print(responseData);
        mechanicServicePriceModel.value = MechanicServicePriceModel.fromJson(responseData??{});
        print(mechanicServicePriceModel.value);

      } else {
        Get.snackbar('Failed', response.message ?? 'Resend otp failed');
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
