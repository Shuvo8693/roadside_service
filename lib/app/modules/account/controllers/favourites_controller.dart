import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/account/model/favourite_model.dart';
import 'package:roadside_assistance/app/modules/account/model/user_profile_model.dart';
import 'package:roadside_assistance/app/modules/account/model/vehicle_model.dart';

import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class FavouritesController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<FavouriteResponse> favouriteResponseModel = FavouriteResponse().obs;
  var isLoading = false.obs;

  Future<void> fetchFavourite() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.favouriteAllUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String, dynamic>? responseData = response.data;
        favouriteResponseModel.value = FavouriteResponse.fromJson(responseData ?? {});
        print(favouriteResponseModel.value);
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