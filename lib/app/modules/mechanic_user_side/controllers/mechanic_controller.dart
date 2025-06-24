import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/favourite_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_details_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MechanicController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<MechanicModel> mechanicModel = MechanicModel().obs;
  var isLoading = false.obs;


  Future<void> fetchMechanic() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.allMechanicUrl(currentPage: 1, limit: 0),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data;
        print(responseData);
        mechanicModel.value =  MechanicModel.fromJson(responseData??{});
        print(mechanicModel.value);

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
  ///====================== Mechanic Details =======================

  Rx<MechanicDetailsModel> mechanicDetailsModel = MechanicDetailsModel().obs;
  var isLoading2 = false.obs;

  Future<void> fetchMechanicDetails() async {
    String token = await PrefsHelper.getString('token');

        String mechanicId = Get.arguments['mechanicId'] ??'';

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.mechanicDetailsUrl(mechanicId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data;
        print(responseData);
        mechanicDetailsModel.value =  MechanicDetailsModel.fromJson(responseData??{});
        print(mechanicDetailsModel.value);

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

  ///====================== Mechanic Favourite ==============================

 final Rx<FavoriteToggleModel> favouriteToggle = FavoriteToggleModel().obs;

  var isLoading3 = false.obs;

  Future<void> toggleFavourite(String mechanicId, {VoidCallback? favCallBack}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading3.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.favouriteUrl(mechanicId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data;
        print(responseData);
        favouriteToggle.value = FavoriteToggleModel.fromJson(responseData??{});
        print(favouriteToggle.value);
        favCallBack!();

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
      isLoading3.value = false;
    }

  }
}
