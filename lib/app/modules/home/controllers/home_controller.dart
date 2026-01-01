import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/google_api_service.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/home/model/mechanic_service_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_model.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/jwt_decoder/jwt_decoder.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class HomeController extends GetxController {

  TextEditingController searchCtrl = TextEditingController();
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<MechanicModel> mechanicModel = MechanicModel().obs;
  var isLoading = false.obs;

  Future<void> fetchMechanicQuery({String? queryService}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.clearInterceptors();
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.searchMechanicUrl(queryService??''),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        print(responseData);
        mechanicModel.value = MechanicModel.fromJson(responseData??{});
        print(mechanicModel.value);

      } else {
        if(!Get.isSnackbarOpen){
          Get.snackbar('Failed', response.message ?? 'Failed to fetch mechanic');
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

  ///====================== Mechanic Service ==============================

  Rx<MechanicServiceModel> mechanicServiceModel = MechanicServiceModel().obs;
  var isLoading2 = false.obs;
  Future<void> fetchMechanicService() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.clearInterceptors();
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.mechanicServiceUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data;
        print(responseData);
        mechanicServiceModel.value =  MechanicServiceModel.fromJson(responseData??{});

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
  ///======================= fetch my location ===============

  RxList<dynamic> myLocation = <dynamic>[].obs;
  RxList<Placemark> placeMark =  <Placemark>[].obs;
  var isLoading3 = false.obs;
  Future<void> fetchMyLocation() async {
    String token = await PrefsHelper.getString('token');
    final decodedData = decodeJWT(token);
    String userId = decodedData['id'];

    _networkCaller.clearInterceptors();
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());


    try {
      isLoading3.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.myLocationUrl(userId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data?['data'] as List<dynamic>;
        myLocation.value = responseData  ;
       List<Placemark> _placeMark = await GoogleApiService.placeMarkFromCoordinate(LatLng(myLocation[1], myLocation[0]));
       print(_placeMark.first.administrativeArea);
        placeMark.value = _placeMark;
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


  @override
  void onClose() {
    searchCtrl.clear();
    super.onClose();
  }
}
