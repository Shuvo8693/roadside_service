import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MetricsCard extends StatelessWidget {
  final String value;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double valueFontSize;
  final double titleFontSize;

  const MetricsCard({
    super.key,
    required this.value,
    required this.title,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.grey,
    this.height = 80.0,
    this.borderRadius = 8.0,
    this.valueFontSize = 18.0,
    this.titleFontSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height.h,
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize.sp,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}