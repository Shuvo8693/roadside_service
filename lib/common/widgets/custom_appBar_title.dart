import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';
import 'package:roadside_assistance/common/app_text_style/style.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';

class CustomAppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarTitle({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.notificationCount,
    this.notificationOnTap, this.isShowChat = false, this.text, this.isShowText = false, this.imageUrl,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final int? notificationCount;
  final VoidCallback? notificationOnTap;
  final bool isShowChat;
  final bool isShowText;
  final String? text;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      title:isShowText? Text(text!,style: AppStyles.h2(),):SvgPicture.asset(AppImage.appLogoImg, height: 45.h),
      centerTitle: true,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CustomNetworkImage(
          imageUrl: imageUrl??'',
          boxShape: BoxShape.circle,
          height: 42.h,width: 42.h,
          boxFit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
            onPressed: notificationOnTap,
            icon: Badge.count(count:notificationCount??0,child: Icon(Icons.notifications_outlined,size: 35.h,color: AppColors.greyColor,),),

        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
