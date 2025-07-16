import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/home/model/mechanic_service_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/views/mechanic_service_view.dart';
import 'package:roadside_assistance/app/modules/my_booking/model/order_booking_response_model.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class MechanicServiceController extends GetxController {
  final List<ServiceItem> addedServices = [];
  // final List<ServiceItem> allServices = [
  //   ServiceItem(
  //     name: 'Towing',
  //     icon: AppIcons.towingIcon,
  //     price: 100,
  //     iconColor: Colors.blue,
  //   ),
  //   ServiceItem(
  //     name: 'Lockout',
  //     icon: AppIcons.lockoutIcon,
  //     price: 100,
  //     iconColor: Colors.orange,
  //   ),
  //   ServiceItem(
  //     name: 'Flat Tire\nRepair',
  //     icon: AppIcons.flatTireIcon,
  //     price: 100,
  //     iconColor: Colors.blue,
  //   ),
  //   ServiceItem(
  //     name: 'Gasoline\nDelivery',
  //     icon: AppIcons.gasolineIcon,
  //     price: 100,
  //     iconColor: Colors.blue,
  //   ),
  //   ServiceItem(
  //     name: 'Jump Start\nService',
  //     icon: AppIcons.jumpStartServiceIcon,
  //     price: 100,
  //     iconColor: Colors.orange,
  //   ),
  // ];

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<MechanicServiceModel> mechanicService = MechanicServiceModel().obs;
  var isLoading = false.obs;

  Future<void> fetchServiceRate() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint: ApiConstants.mechanicServiceRateUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        mechanicService.value = MechanicServiceModel.fromJson(responseData ?? {});
        print(mechanicService.value);
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
  ///======================Add service =================
  var isLoadingAdd = false.obs;
  Future<void> addService({String? serviceId , String? price , VoidCallback? callBack}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    final body = {
      "serviceId" : serviceId,
      "price" : price
    };

    try {
      isLoadingAdd.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.addServiceRateUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
         final responseMessage = response.data?['message']??'';
         callBack!();
         if(!Get.isSnackbarOpen){
           Get.snackbar('Successfully', responseMessage);
         }
      } else {
        if(!Get.isSnackbarOpen){
          Get.snackbar('Failed', response.message ?? 'Failed to fetch booking');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    } finally {
      isLoadingAdd.value = false;
    }
  }

  ///======================Delete service =================
  var isLoadingDel = false.obs;
  Future<void> deleteService({String? serviceId  , VoidCallback? callBack}) async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoadingDel.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint: ApiConstants.deleteServiceUrl(serviceId??''),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        final responseMessage = response.data!['message'];
        callBack!();
        Get.snackbar('Successfully', responseMessage);
      } else {
        Get.snackbar('Failed', response.message ?? 'Failed to fetch booking');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw NetworkException('$e');
    } finally {
      isLoadingDel.value = false;
    }
  }

}
