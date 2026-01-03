import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roadside_assistance/app/modules/account/controllers/account_controller.dart';
import 'package:roadside_assistance/app/modules/account/widgets/info_field.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

import '../model/user_profile_model.dart';


class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {

  final AccountController _accountController =Get.put(AccountController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _accountController.fetchProfile(isUser: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(16.0.sp),
            child: Obx(() {
              ProfileData? profileData = _accountController.profileModel.value.data;
              return Column(
                children: [
                  // Header with back arrow and title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      const Expanded(
                        child: Text('My Info',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48.w), // Spacer for alignment
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Profile picture with edit icon
                  Stack(
                    children: [
                      _accountController.profileImagePath.value.isNotEmpty
                          ? Container(
                        height: 125.h,
                        width: 125.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 3),
                          image: DecorationImage(image: FileImage(File(_accountController.profileImagePath.value)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ) : CustomNetworkImage(imageUrl: '${profileData?.user?.image}',
                        height: 125.h,
                        width: 125.h,
                        boxShape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3.w),
                      ),
                      Positioned(
                        bottom: 4.h,
                        right: 4.w,
                        child: InkWell(
                          onTap: () async{
                          await _accountController.pickImageFromCameraForProfilePic(ImageSource.gallery);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.sp),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Full Name field
                   InfoField(
                    label: 'Full Name',
                    textEditingController: _accountController.nameCtrl,
                     readOnly: false,
                  ),
                  SizedBox(height: 20.h),
                  // Phone Number field
                   InfoField(
                    label: 'Phone Number',
                    textEditingController: _accountController.phoneNumber,
                     readOnly: false,
                  ),
                  SizedBox(height: 20.h),
                  // Email field with Change button
                  InfoField(
                    label: 'Email',
                    textEditingController: _accountController.emailCtrl,
                    suffixText: 'Change',
                    suffixOnTap: (){
                      Get.toNamed(Routes.FORGOT_PASSWORD);
                    }, readOnly: true,
                  ),
                  verticalSpacing(30.h),
                  Obx(() {
                    return CustomButton(
                      loading: _accountController.isLoading2.value ,
                        onTap: () async {
                          await _accountController.updateProfile(_accountController.selectedProfileImage ?? File(''));
                        },
                        text: 'Update'
                    );
                  }

                  )
                ],
              );
            }
            ),
          ),
        ),
      ),
    );
  }
}


