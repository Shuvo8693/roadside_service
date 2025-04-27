import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';

class ServiceCategoryContainer extends StatelessWidget {
  final String category;
  final String icon;

  const ServiceCategoryContainer({super.key, required this.category, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon),
          SizedBox(height: 10.h),
          Text(category, textAlign: TextAlign.center,style: GoogleFontStyles.h5(),
          ),
        ],
      ),
    );
  }
}
