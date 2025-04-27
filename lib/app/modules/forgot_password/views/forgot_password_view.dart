import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_string/app_string.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/app_text_style/style.dart';

import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';
import 'package:roadside_assistance/common/widgets/text_required.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordController _forgotPasswordController =
      Get.put(ForgotPasswordController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 4,),
              Text('Forget Password',style: GoogleFontStyles.h1(fontWeight: FontWeight.w500),),
              verticalSpacing(8),
              Text('No need to worry',style: GoogleFontStyles.h5(color: AppColors.primaryColor),),
              const Spacer(flex: 1,),
              ///Email
              verticalSpacing(10.h),
              TextRequired(
                text: AppString.emailText,
                textStyle: AppStyles.h4(family: "Schuyler"),
              ),
              verticalSpacing(10.h),
              CustomTextField(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: const Icon(
                    Icons.mail,
                    color: AppColors.appGreyColor,
                    size: 20,
                  ),
                ),
                filColor: AppColors.textFieldFillColor,
                isEmail: true,
                keyboardType: TextInputType.emailAddress,
                contentPaddingVertical: 20.h,
                hintText: "Type your email",
                labelTextStyle:
                    const TextStyle(color: AppColors.primaryColor),
                controller: _forgotPasswordController.emailCtrl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  return null;
                },
              ),

              /// Action button
              verticalSpacing(30.h),
              Obx(() {
                return CustomButton(
                  loading: _forgotPasswordController.isLoading.value,
                  onTap: () async {
                    Get.toNamed(Routes.OTP,arguments: {'isResetPass':true});
                    if (_formKey.currentState!.validate()) {
                      //await _verifyEmailController.sendMail(isResetPassword);
                    }
                  },
                  text: 'Send Code',
                  // Disable button if loading
                );
              }),
              const Spacer(flex: 8,),
            ],
          ),
        ),
      ),
    );
  }
}
