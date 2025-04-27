import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/onboarding/widgets/pagination_dot.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';

class Onboarding3View extends StatelessWidget {
  const Onboarding3View({super.key});

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
                AppImage.onboarding3Img,
                width: 334.453.w,
                height: 333.382.h  // Adjust size as needed
            ),

            SizedBox(height: 20.h),
            // Main text
            Text(
              'Instant Help, Anytime, Anywhere',
              style: GoogleFontStyles.h2(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            // Subtext
            Text(
              'Stranded on the road? Beep Roadside connects you with reliable roadside assistance in minutes. ',
              textAlign: TextAlign.center,
              style: GoogleFontStyles.h5(color: Colors.grey,fontSize: 13.sp),
            ),
            Spacer(),
            // Pagination dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DotWidget(),
                DotWidget(),
                DotWidget(index: 1),
              ],
            ),
            Spacer(),
            CustomButton(
              onTap: (){
                Get.toNamed(Routes.ROLE);
              },
              text: 'Get Started',
              textStyle: GoogleFontStyles.h4(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

}
