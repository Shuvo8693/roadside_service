import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/check_out/model/vehiclelist_model.dar.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class VehicleController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<VehicleListModel> vehicleListModel = VehicleListModel().obs;
  var isLoading = false.obs;
 // RxMap<int,bool> isCarSelected={};
  RxString selectedValue =''.obs;

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
  var isLoading2 = false.obs;

  Future<void> addVehicle() async {
    String token = await PrefsHelper.getString('token');

    Map<String ,dynamic> body = {
      "model": vehicleModelCtrl.text,
      "brand": vehicleBrandCtrl.text,
      "number": vehicleNumberCtrl.text
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.addVehicleUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        print(responseData);
        Get.snackbar('Successfully', response.message ?? 'vehicle added');

      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to added vehicle');
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

}


