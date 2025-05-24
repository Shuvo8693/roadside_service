import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';

class CustomDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? textColor;
  final String routeName;
  final bool isLogout;

  const CustomDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.textColor,
    required this.routeName,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : iconColor ?? AppColors.primaryColor,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: isLogout ? Colors.red : textColor ?? Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: AppColors.primaryColor,
      ),
      onTap: () {
        if (isLogout) {
          Get.offAllNamed(routeName); // Clear navigation stack for logout
        } else {
          Get.toNamed(routeName);
        }
      },
    );
  }
}