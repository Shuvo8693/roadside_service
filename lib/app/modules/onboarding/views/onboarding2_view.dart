import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/onboarding/widgets/pagination_dot.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/app_text_style/style.dart';
import 'package:roadside_assistance/common/widgets/custom_icon_button_with_text.dart';

class Onboarding2View extends StatelessWidget {
  const Onboarding2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Spacer(),
            // SVG image
            SvgPicture.asset(
                AppImage.onboarding2Img,
                width: 334.453.w,
                height: 333.382.h  // Adjust size as needed
            ),

            SizedBox(height: 20.h),
            // Main text
            Text(
              'Safe & Secure Assistance',
              style: GoogleFontStyles.h2(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            // Subtext
            Text(
              'Our trusted professionals ensure quick, safe, and affordable service whenever you need it. ',
              textAlign: TextAlign.center,
              style: GoogleFontStyles.h5(color: Colors.grey,fontSize: 13.sp),
            ),
            Spacer(),
            // Pagination dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DotWidget(),
                DotWidget(index: 1),
                DotWidget(),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.SIGN_IN);
                  },
                  child: Text('Skip', style: GoogleFontStyles.h4(color: Colors.black)),
                ),
                CustomIconButtonWithText(
                  onTap: (){
                    Get.toNamed(Routes.ONBOARDING3);
                  },
                  text: 'Next',
                  icon: Icon(Icons.arrow_forward,color: Colors.white,),
                  iconAlignment: IconAlignment.end,
                  width: 100.w,
                  textStyle: GoogleFontStyles.h4(color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}
