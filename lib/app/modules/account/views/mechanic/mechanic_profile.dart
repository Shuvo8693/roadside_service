import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/account/widgets/info_field.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';


class MechanicProfile extends StatelessWidget {
  const MechanicProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(16.0.sp),
          child: Column(
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
                  CustomNetworkImage(
                    imageUrl: AppConstants.mechanicImage,
                    height: 150.h,
                    width: 150.h,
                    boxShape: BoxShape.circle,
                  ),
                  Positioned(
                    bottom: 4.h,
                    right: 4.w,
                    child: InkWell(
                      onTap: (){

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
              const InfoField(
                label: 'Full Name',
                value: 'Jhon Mc',
              ),
              SizedBox(height: 20.h),
              /// experiance
              const InfoField(
                label: 'Experience',
                value: '7 years',
              ),
              SizedBox(height: 20.h),
              /// Phone Number field
              const InfoField(
                label: 'Profession',
                value: 'Mechanic',
              ),
              SizedBox(height: 20.h),
              /// Bio
              const InfoField(
                label: 'Bio',
                value: 'alksdjlaksjdlkasjdlkjasdlkj',
                maxLine: 4,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}


