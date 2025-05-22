import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_string/app_string.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/app_text_style/style.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';

import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_card.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';
import 'package:roadside_assistance/common/widgets/have_an_account_text_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final SignInController _loginController = Get.put(SignInController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar:  AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back',style: GoogleFontStyles.h1(fontWeight: FontWeight.w500),),
                    verticalSpacing(8),
                    Text('Where connecting begins',style: GoogleFontStyles.h5(color: AppColors.primaryColor),),
                    verticalSpacing(25.h),
                    Text(AppString.emailText,
                      style: AppStyles.h4(family: "Schuyler"),
                    ),
                    verticalSpacing(10.h),
                    CustomTextField(
                      prefixIcon:  Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 8.w),
                        child: const Icon(
                          Icons.mail,
                          color: AppColors.appGreyColor,
                          size: 20,
                        ),
                      ),
                      filColor: AppColors.textFieldFillColor,
                      isEmail: true,
                      contentPaddingVertical: 20.h,
                      hintText: "Type your email",
                      labelTextStyle:
                      const TextStyle(color: AppColors.primaryColor),
                      controller: _loginController.emailCtrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                        return null;
                      },
                    ),

                    verticalSpacing(20.h),
                    Text(AppString.passawordText,
                      style: AppStyles.h4(family: "Schuyler"),
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
                      hintText: "Type your password",
                      labelTextStyle:
                      const TextStyle(color: AppColors.primaryColor),
                      isObscureText: true,
                      obscure: '*',
                      isPassword: true,
                      controller: _loginController.passCtrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          Get.toNamed(Routes.FORGOT_PASSWORD);
                          String token = await PrefsHelper.getString('token');
                          if (token.isNotEmpty) {
                            //Get.toNamed(AppRoutes.emailveryfaiScreen);
                          }
                        },
                        child: Text(
                          "Forgot Password?",
                          style: AppStyles.customSize(
                              size: 14,
                              family: "Schuyler",
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent),
                        ),
                      ),
                    ),

                    /// Login Button

                    SizedBox(height: 20.h),
                    Obx(() {
                      return CustomButton(
                          loading: _loginController.verifyLoading.value,
                          onTap: () async {
                           String? userRole =await PrefsHelper.getString('role');
                           if(userRole =='User'){
                             Get.toNamed(Routes.HOME);
                           } else if(userRole =='Mechanic'){
                             Get.toNamed(Routes.MECHANIC_HOME);
                           }else{
                             Get.snackbar('Failed route', ' Select your role before route home');
                           }
                            /* if (_formKey.currentState!.validate()) {
                                  await _loginController.login();
                                }*/
                          },
                          textStyle: AppStyles.h2(color: AppColors.white),
                          text: AppString.loginText);
                    }),

                    /// Route SignUpScreen
                    SizedBox(height: 50.h),
                    HaveAnAccountTextButton(
                      onTap: () {
                        Get.toNamed(Routes.ROLE );
                      },
                      firstText: "Don’t have an account? ",
                      secondText: AppString.signupText,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        );

  }
}
