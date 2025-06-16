import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/signup/controllers/signup_controller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignupController _signupController = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();
   bool _hasMinLength = false;
   bool _hasLowerCase = false;
   bool _hasSpecialChar = false;
   bool isAgreeWithTerms = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
                  style: GoogleFontStyles.h1(),
                ),
                verticalSpacing(10.h),
                Text(
                  'It only takes a minute!',
                  style: GoogleFontStyles.h3(color: AppColors.primaryColor),
                ),
                /// Full name
                SizedBox(height: 25.h),
                CustomTextField(
                  controller: _signupController.fullNameController,
                  hintText: 'Full Name',
                  prefixIcon:  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.appGreyColor,
                      size: 20,
                    ),
                  ),
                  filColor: AppColors.textFieldFillColor,
                  contentPaddingVertical: 20.h,
                  labelTextStyle:
                  const TextStyle(color: AppColors.primaryColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                /// Mail
                verticalSpacing(15.h),
                CustomTextField(
                  controller: _signupController.emailController,
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                /// Phone number
                verticalSpacing(15.h),
                CustomTextField(
                  controller: _signupController.phoneNumberController,
                  hintText: 'Phone Number',
                  prefixIcon:  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: const Icon(
                      Icons.phone,
                      color: AppColors.appGreyColor,
                      size: 20,
                    ),
                  ),
                  filColor: AppColors.textFieldFillColor,
                  contentPaddingVertical: 20.h,
                  labelTextStyle:
                  const TextStyle(color: AppColors.primaryColor),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                /// Password
                verticalSpacing(15.h),
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
                  controller: _signupController.passwordController,
                  onChange: validatePassword ,
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
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Checkbox(
                        value: isAgreeWithTerms,
                        onChanged: (value) {
                            setState(() {
                              isAgreeWithTerms=value!;
                            });
                           }
                        ),
                    Text('Agree with ',style: GoogleFontStyles.h5(),),
                    GestureDetector(
                      onTap: () {
                        // Open terms and condition page
                      },
                      child: Text(
                        'Terms & Condition',
                        style: GoogleFontStyles.h5(color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                isAgreeWithTerms?
                Obx(()=>
                   CustomButton(
                    loading: _signupController.isLoading.value,
                    onTap: ()async {
                      if (_formKey.currentState!.validate()) {
                        await  _signupController.createUser();
                      }
                    }, text: 'SignUp',
                  ),
                ): CustomButton(
                  color: Colors.grey,
                  onTap: (){}, text: 'SignUp',
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",style: GoogleFontStyles.h5(),),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.SIGN_IN);
                      },
                      child: Text('Log in now',style: GoogleFontStyles.h5(),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
}

