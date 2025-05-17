import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveOrderAndPaymentCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isShowStatus;
  final int statusCount;
  final Color borderColor;
  final Color badgeBackgroundColor;

  const ActiveOrderAndPaymentCard({
    super.key,
    required this.text,
    required this.icon,
    this.isShowStatus = false,
    this.statusCount = 0,
    this.borderColor = Colors.grey,
    this.badgeBackgroundColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            Icon(icon, size: 20.r),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                if (isShowStatus)
                  Badge.count(
                    count: statusCount,
                    backgroundColor: badgeBackgroundColor,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}