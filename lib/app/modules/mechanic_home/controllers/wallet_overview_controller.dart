import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/model/wallet_overview_response.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class WalletOverviewController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<WalletOverviewResponse> walletOverviewResponse = WalletOverviewResponse().obs;
  var isLoading = false.obs;


  Future<void> fetchWalletOverview() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.walletOverviewUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String, dynamic>? responseData = response.data;
        print(responseData);
        walletOverviewResponse.value = WalletOverviewResponse.fromJson(responseData ?? {});
        print(walletOverviewResponse.value);
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
