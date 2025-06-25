import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/check_out/model/mechanic_service_price_model.dart';
import 'package:roadside_assistance/app/modules/check_out/model/service_rate_model.dart';
import 'package:roadside_assistance/app/modules/check_out/model/vehiclelist_model.dar.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class VehicleController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<VehicleListModel> vehicleListModel = VehicleListModel().obs;
  var isLoading = false.obs;
  RxBool? isCarSelected=false.obs;

  Future<void> fetchVehicle() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.allVehicleUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        print(responseData);
        vehicleListModel.value = VehicleListModel.fromJson(responseData??{});
        print(vehicleListModel.value);

      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to fetch Vehicle');
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

  /// ================== Add Vehicle ================================

  final TextEditingController vehicleModelCtrl = TextEditingController();
  final TextEditingController vehicleBrandCtrl = TextEditingController();
  final TextEditingController vehicleNumberCtrl = TextEditingController();

  Future<void> addVehicle() async {
    String token = await PrefsHelper.getString('token');

    Map<String ,dynamic> body ={
      "model": "Premio",
      "brand": "Toyota",
      "number": "DEF-3322"
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.addVehicleUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        print(responseData);
        Get.snackbar('Successfully', response.message ?? 'Book a service');

      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to book a service');
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


