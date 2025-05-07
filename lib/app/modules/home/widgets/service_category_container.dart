import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

class ServiceCategoryContainer extends StatelessWidget {
  final String category;
  final String icon;
  final String? price;
  final VoidCallback? bookNowOnTap;
  final bool? isActiveBooking;

  const ServiceCategoryContainer({
    super.key,
    required this.category,
    required this.icon,
    this.isActiveBooking,
    this.price,
    this.bookNowOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon),
          SizedBox(height: 10.h),
          Text(
            category,
            textAlign: TextAlign.center,
            style: GoogleFontStyles.h5(),
          ),
          if (isActiveBooking == true)
            Column(
              children: [
                verticalSpacing(8.h),
                Text(price??'',style: GoogleFontStyles.h4(),),
                CustomButton(
                  height: 40.h,
                  width: 100.w,
                  onTap: bookNowOnTap ?? () {},
                  text: 'Book now',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
