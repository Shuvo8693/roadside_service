import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/data/network_caller.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/favourite_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_details_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/mechanic_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/model/review_response.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

class RatingReviewController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<ReviewResponse> reviewResponse = ReviewResponse().obs;
  var isLoading = false.obs;


  Future<void> fetchReview() async {
    String token = await PrefsHelper.getString('token');
    String  mechanicId = Get.arguments['mechanicId']??'';

    _networkCaller.clearInterceptors();
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.reviewUrl(mechanicId),
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data;
        print(responseData);
        reviewResponse.value = ReviewResponse.fromJson(responseData??{});
        print(reviewResponse.value);

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

  var isLoading2 = false.obs;

  Future<void> postReview({Review? review,VoidCallback? callBack}) async {
    String token = await PrefsHelper.getString('token');
    final body ={
      "order" : review?.order,
      "rating" : review?.rating,
      "comment"  : review?.comment
    };
    _networkCaller.clearInterceptors();
    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2.value = true;
      final response = await _networkCaller.post<Map<String, dynamic>>(
        endpoint:  ApiConstants.giveReviewUrl,
        body: body,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data?['message'];
        Get.snackbar('Success', responseMessage);
        callBack?.call();
      } else {
        String responseMessage = response.data?['errorMessage'];
        Get.snackbar('Failed', responseMessage);
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
}
class Review {
  final String? order;
  final int? rating;
  final String? comment;

  Review({this.order, this.rating, this.comment});
}
