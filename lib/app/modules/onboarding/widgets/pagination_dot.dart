import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotWidget extends StatelessWidget {
  final int index;
  const DotWidget({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: index == 1 ? 30.w : 15.h, // Use screen size scaling with ScreenUtil
      height: 15.h,
      decoration: BoxDecoration(
        color: index != 0 ? Colors.black : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10.r), // Using screen size scaling
        border: Border.all(
          color: index != 0 ? Colors.transparent : Colors.grey.shade400,
          width: 1.0,
        ),
      ),
    );
  }
}
