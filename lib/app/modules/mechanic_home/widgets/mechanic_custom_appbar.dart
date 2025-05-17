import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';

class MechanicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String avatarUrl;
  final String name;
  final String title;
  final String statusText;


  const MechanicAppBar({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.title,
    this.statusText = 'Active Status',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CircleAvatar(
        radius: 24.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: CustomNetworkImage(
            imageUrl: avatarUrl,
            width: 48.r,
            height: 48.r,
            boxFit: BoxFit.cover,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Text(
              statusText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Transform.scale(
              scale: 0.8.r,
              child: Switch(
                activeColor: Colors.green ,
                  value: true,
                  onChanged: (value){

              }),
            )

          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}