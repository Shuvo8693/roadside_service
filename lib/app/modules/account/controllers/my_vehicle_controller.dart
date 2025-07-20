import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/account/model/user_profile_model.dart';
import 'package:roadside_assistance/app/modules/account/model/vehicle_model.dart';

import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MyVehicleController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<VehicleResponse> vehicleModel = VehicleResponse().obs;
  var isLoading = false.obs;

  Future<void> fetchVehicle() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.myVehicleUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data;
        vehicleModel.value =  VehicleResponse.fromJson(responseData??{});
        print(vehicleModel.value);

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

  /// create vehicle
  var isLoading2 = false.obs;
  Future<void> createVehicle({Vehicle? vehicle}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    final body ={
        "model": vehicle?.model,
        "brand": vehicle?.brand,
        "number": vehicle?.number
    };

    try {
      isLoading2.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.vehicleCreateUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data!['message'];
        Get.snackbar('Success', responseMessage);
        await fetchVehicle();

      } else {
        if (kDebugMode) {
          print(response.message);
        }
        if(Get.isSnackbarOpen){
          Get.snackbar('Success', response.toString() );
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


  /// Delete vehicle

  Future<void> deleteVehicle({String? vehicleId, VoidCallback? callBack}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());


    try {
      final response = await _networkCaller.delete<Map<String, dynamic>>(
        endpoint:  ApiConstants.vehicleDeleteUrl(vehicleId??''),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        callBack!.call();
      } else {
        if (kDebugMode) {
          print(response.message);
        }
        if(!Get.isSnackbarOpen){
          Get.snackbar('Success', response.toString() );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    }
  }

}
