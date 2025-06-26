import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/check_out/model/mechanic_service_price_model.dart';
import 'package:roadside_assistance/app/modules/check_out/model/service_rate_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class CheckOutController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<MechanicServicePriceModel> mechanicServicePriceModel = MechanicServicePriceModel().obs;
  var isLoading = false.obs;
  RxList<ServiceRate> serviceRateList = <ServiceRate>[].obs;
  RxBool? isSelected=false.obs;

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
        Get.snackbar('Failed', response.message ?? 'Failed to fetch service');
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

  /// ================== Checkout Book ================================
  final TextEditingController pickupAddressCtrl = TextEditingController();
  final TextEditingController streetNoCtrl = TextEditingController();
  final TextEditingController additionalNoteCtrl = TextEditingController();

  Future<void> book({String? vehicleId,LatLng? coordinates, VoidCallback? callBack}) async {
    String token = await PrefsHelper.getString('token');
   String mechanicId = Get.arguments['mechanicId'] ?? '';

    Map<String ,dynamic> body ={
      "mechanic": mechanicId,
      "services": serviceRateList.map((service)=>service.serviceId).toList(),
      "vehicle": vehicleId,
      "streetNo": streetNoCtrl.text.trim(),
      "address": pickupAddressCtrl.text.trim(),
      "additionalNotes": additionalNoteCtrl.text.trim(),
      "coordinates": [coordinates?.longitude, coordinates?.latitude]  // [lng,lat]
    };

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.bookOrderUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        callBack!();
        print(responseData);
        Get.snackbar('Successfully', response.message ?? 'Booked a service');

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


