import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  _RoleViewState createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  String? selectedRole = 'User'; // Default selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.all(16.0.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              'Who you are',
              style: GoogleFontStyles.h1(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select Before Sign Up',
              style: GoogleFontStyles.h5(color: AppColors.primaryColor),
            ),
            ///======User=======
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRole = 'User';
                });
              },
              child: Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: selectedRole == 'User' ? AppColors.primary100Color : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'User',
                      style: GoogleFontStyles.h4(color: selectedRole == 'User' ? AppColors.primaryColor : Colors.black,),
                    ),
                    Icon(
                      selectedRole == 'User' ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: selectedRole == 'User' ? AppColors.primaryColor : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            ///======Mechanic=======
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRole = 'Mechanic';
                });
              },
              child: Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: selectedRole == 'Mechanic' ? AppColors.primary100Color : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mechanic',
                      style: GoogleFontStyles.h4(color: selectedRole == 'Mechanic' ? AppColors.primaryColor : Colors.black,)
                    ),
                    Icon(
                      selectedRole == 'Mechanic' ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: selectedRole == 'Mechanic' ? AppColors.primaryColor : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            //SizedBox(height: 32.h),
            Spacer(),
            CustomButton(
              onTap: (){
               print(selectedRole);
               Get.toNamed(Routes.SIGNUP);
              },
              text: 'Next',
              textStyle: GoogleFontStyles.h4(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
