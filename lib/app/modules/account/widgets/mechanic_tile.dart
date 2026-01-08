import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_drawer/custom_drawer_tile.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/delete_alert_dialogue.dart';
class MechanicTile extends StatelessWidget {
  final Function() onTap;
  const MechanicTile({
    super.key , required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        /// My Info
        CustomDrawerTile(
          icon: Icons.person_outline,
          title: 'My Profile',
          routeName: Routes.MECHANIC_PROFILE,
        ),
        /// My service
        CustomDrawerTile(
          icon: Icons.history,
          title: 'My Service',
          routeName: Routes.MECHANIC_SERVICE,
        ),
        /// Payment
        CustomDrawerTile(
          icon: Icons.payment_outlined,
          title: 'Payment',
          routeName: Routes.MECHANIC_PAYMENT_METHOD,
        ),
        /// Review
        CustomDrawerTile(
          icon: Icons.star_outline,
          title: 'Review',
          routeName: Routes.RATINGANDREVIEW,
        ),
        /// Password Change
        CustomDrawerTile(
          icon: Icons.lock_outline,
          title: 'Password Change',
          routeName: Routes.CHANGE_PASSWORD,
        ),
        // About Us
        CustomDrawerTile(
          icon: Icons.info_outline,
          title: 'About Us',
          routeName: Routes.ABOUTUS,
        ),
        // Log Out
        CustomDrawerTile(
          icon: Icons.logout,
          title: 'Log Out',
          routeName: Routes.SIGN_IN,
          isLogout: true,
        ),
        SizedBox(height: 100.h),
        CustomButton(
          onTap: onTap, text: "Delete Account",color: Colors.red,),
      ],
    );
  }
}