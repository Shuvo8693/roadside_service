import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;

import 'package:image_picker/image_picker.dart';

import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/modules/account/model/user_profile_model.dart';

import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

import '../../../data/network_caller.dart';

class AccountController extends GetxController {

  final NetworkCaller _networkCaller = NetworkCaller.instance;
  Rx<ProfileModel> profileModel = ProfileModel().obs;
  var isLoading = false.obs;

  Future<void> fetchProfile() async {
    String token = await PrefsHelper.getString('token');

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading.value = true;
      final response = await _networkCaller.get<Map<String, dynamic>>(
        endpoint:  ApiConstants.userProfileUrl,
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        Map<String,dynamic>? responseData = response.data;
        profileModel.value =  ProfileModel.fromJson(responseData??{});
        getProfile();
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

  getProfile() {
    nameCtrl.text = profileModel.value.data?.user?.name ?? '';
    phoneNumber.text = profileModel.value.data?.user?.phone ?? '';
    emailCtrl.text = profileModel.value.data?.user?.email ?? '';
  }

  ///=============== update profile ========================

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  File? selectedProfileImage;
  var profileImagePath = ''.obs;
  var isLoading2 = false.obs;

  Future<void> updateProfile( File imageFile ) async {
    String token = await PrefsHelper.getString('token');

    final multipartFile = await MultipartFile.fromFile(
      field: 'image',
      file: imageFile,
      contentType: 'image/jpeg',
    );
    Map<String,dynamic> userData = {};
    if(nameCtrl.text.isNotEmpty) userData['name'] = nameCtrl.text;
    if(phoneNumber.text.isNotEmpty) userData['phone'] = phoneNumber.text;

    _networkCaller.addRequestInterceptor(ContentTypeInterceptor());
    _networkCaller.addRequestInterceptor(AuthInterceptor(token: token));
    _networkCaller.addResponseInterceptor(LoggingInterceptor());

    try {
      isLoading2.value = true;
      final response = await _networkCaller.multipart<Map<String, dynamic>>(
        endpoint:  ApiConstants.updateProfileUrl,
        fields: {
          'data' : jsonEncode(userData)
        },
        files: [multipartFile],
        timeout: Duration(seconds: 10),
        fromJson: (json) => json as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        String responseMessage = response.data!['message'];
        Get.snackbar('Successfully', responseMessage);

      } else {
        Get.snackbar('Failed', response.message??'');
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

  Future<void> pickImageFromCameraForProfilePic(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);

    if (returnImage == null) return;

    selectedProfileImage = File(returnImage.path);
    profileImagePath.value = selectedProfileImage!.path;

    update(); // Updates the UI
    print('ImagePath: ${profileImagePath.value}');

  }

}
