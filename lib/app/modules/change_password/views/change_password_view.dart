import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_string/app_string.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/app_text_style/style.dart';

import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';
import 'package:roadside_assistance/common/widgets/show_status_change_pass_item.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';
import 'package:roadside_assistance/common/widgets/text_required.dart';
import 'package:lottie/lottie.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends StatefulWidget{
   const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final ChangePasswordController _changePasswordController=Get.put(ChangePasswordController());

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hasMinLength = false;
  bool _hasLowerCase = false;
  bool _hasSpecialChar = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // const Spacer(flex: 1,),
                verticalSpacing(30.h),
                Text('Reset Your Password',style: GoogleFontStyles.h1(fontWeight: FontWeight.w500),),
                verticalSpacing(8.h),
                Text("It only take a minute!",style: GoogleFontStyles.h5(color: AppColors.primaryColor),),
                ///Password
                verticalSpacing(30.h),
                TextRequired(text:AppString.passawordText,
                  textStyle: AppStyles.h4(family: "Schuyler"),
                ),
                verticalSpacing(10.h),
                CustomTextField(
                  filColor: AppColors.textFieldFillColor,
                  suffixIconColor: AppColors.appGreyColor,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: SvgPicture.asset(AppIcons.lockIcon),
                  ),
                  contentPaddingVertical: 20.h,
                  hintText: "Type a password",
                  labelTextStyle:
                  const TextStyle(color: AppColors.primaryColor),
                  isObscureText: true,
                  obscure: '*',
                  isPassword: true,
                  onChange: validatePassword,
                  controller: _changePasswordController.newPassCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter password';
                    }
                    return null;
                  },
                ),
                verticalSpacing(15.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password must contain',style: GoogleFontStyles.h5(fontWeight: FontWeight.w500),),
                    verticalSpacing(8.h),
                    _passwordRequirement('8 Characters', _hasMinLength),
                    _passwordRequirement('1 Upper case character', _hasLowerCase),
                    _passwordRequirement('1 Special character', _hasSpecialChar),
                  ],
                ),
                ///Confirm-Password
                SizedBox(height: 20.h),
                TextRequired(text:'Re-type password',
                  textStyle: AppStyles.h4(family: "Schuyler"),
                ),
                verticalSpacing(10.h),
                CustomTextField(
                  filColor: AppColors.textFieldFillColor,
                  suffixIconColor: AppColors.appGreyColor,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: SvgPicture.asset(AppIcons.lockIcon),
                  ),
                  contentPaddingVertical: 20.h,
                  hintText: "Re-type your password",
                  labelTextStyle:
                  const TextStyle(color: AppColors.primaryColor),
                  isObscureText: true,
                  obscure: '*',
                  isPassword: true,
                  controller: _changePasswordController.confirmPassCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Re-type your password';
                    }else if(_changePasswordController.newPassCtrl.text != value){
                      return "Password don't matched";
                    }
                    return null;
                  },
                ),
                /// Action button
                verticalSpacing(40.h),
                CustomButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        //await otpController.sendOtp(isResetPassword);
                        showStatusOnChangePasswordResponse(context);
                      }
                    },
                    text: AppString.confirmText),
               // const Spacer(flex: 2,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showStatusOnChangePasswordResponse(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return ShowStatusOnChangePassItem(
          onTap: () {
            Get.offAllNamed(Routes.SIGN_IN);
            },
        );
      },
    );
  }

  // Helper widget to show password requirement
  Widget _passwordRequirement(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
        ),
        SizedBox(width: 4),
        Text(text,style: GoogleFontStyles.h5(),),
      ],
    );
  }

  // Function to validate password
  validatePassword(String? password) {
    if(password!=null){
      setState(() {
        _hasMinLength = password.length >= 8;
        _hasLowerCase = RegExp(r'[A-Z]').hasMatch(password);
        _hasSpecialChar = RegExp(r'[\W_]').hasMatch(password);
      });
    }
  }
  @override
  void dispose() {
    _changePasswordController.newPassCtrl.clear();
    _changePasswordController.confirmPassCtrl.clear();
    super.dispose();
  }
}


