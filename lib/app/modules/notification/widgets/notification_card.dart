import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';

class NotificationTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback? onTap;

  const NotificationTile({super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading:  CustomNetworkImage(
        imageUrl: image??'',
        boxShape: BoxShape.circle,
        height: 48.h,width: 48.h,
        boxFit: BoxFit.cover,
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.w),
    );
  }
}