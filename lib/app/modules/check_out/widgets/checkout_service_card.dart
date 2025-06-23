import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ensure this package is added

class CheckOutServiceCard extends StatelessWidget {
  final String serviceName;
  final String price;
  final String? svgPath;
  final VoidCallback iconButton;
  final IconData? icon;
  final Color? iconColor;

  const CheckOutServiceCard({
    super.key,
    required this.serviceName,
    required this.price,
    this.svgPath,
    required this.iconButton,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: svgPath != null
              ? SvgPicture.network(
            svgPath!,
            height: 24.h, // Adjust size as needed
            width: 24.w,
          )
              : null, // No leading icon if svgAssetPath is null
          title: Text(
            serviceName,
            style: TextStyle(fontSize: 16.sp),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                price,
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: iconButton,
                  child: Icon(icon??Icons.close, color:iconColor??Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}