import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roadside_assistance/app/modules/account/controllers/account_controller.dart';
import 'package:roadside_assistance/app/modules/account/model/user_profile_model.dart';
import 'package:roadside_assistance/app/modules/account/widgets/info_field.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';


class MechanicProfile extends StatefulWidget {
  const MechanicProfile({super.key});

  @override
  State<MechanicProfile> createState() => _MechanicProfileState();
}

class _MechanicProfileState extends State<MechanicProfile> {

  final AccountController _accountController = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _accountController.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(16.0.sp),
            child: Obx((){
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
                        child: Text(
                          'My Profile',
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
                      _accountController.profileMecImagePath.value.isNotEmpty
                          ? Container(
                        height: 125.h,
                        width: 125.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 3),
                          image: DecorationImage(image: FileImage(File(_accountController.profileMecImagePath.value)),
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
                          onTap: ()async{
                            await _accountController.pickImageFromCameraForMechProfilePic(ImageSource.gallery);
                          },
                          child: Container(
                            padding:  EdgeInsets.all(4.sp),
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
                  /// Full Name field
                  InfoField(
                    label: 'Full Name',
                    textEditingController: _accountController.mechanicNameCtrl,
                    readOnly: false,

                  ),
                  SizedBox(height: 20.h),
                  /// experiance
                  InfoField(
                    label: 'Experience',
                    textEditingController: _accountController.mechanicExpCtrl,
                    readOnly: false,
                  ),
                  SizedBox(height: 20.h),
                  /// Phone Number field
                  InfoField(
                    label: 'Phone number',
                    textEditingController: _accountController.mechanicPhoneNumber,
                    readOnly: false,
                  ),
                  SizedBox(height: 20.h),
                  /// Bio
                  InfoField(
                    label: 'Bio',
                    textEditingController: _accountController.bioCtrl,
                    maxLine: 4,
                    readOnly: false,
                  ),

                  verticalSpacing(30.h),
                  Obx(() {
                    return CustomButton(
                        loading: _accountController.isLoading3.value ,
                        onTap: () async {
                          if (_accountController.selectedMecProfileImage?.path != null) {
                            await _accountController.updateMechProfile(_accountController.selectedMecProfileImage ?? File(''));
                          }
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


