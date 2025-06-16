import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_drawer/custom_drawer_tile.dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_outlinebutton.dart';

import '../../../../common/app_text_style/style.dart';
class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        // My Info
        CustomDrawerTile(
          icon: Icons.person_outline,
          title: 'My Info',
          routeName: Routes.MYINFO,
        ),
        // Favourite
        CustomDrawerTile(
          icon: Icons.favorite_border,
          title: 'Favourite',
          routeName: Routes.FAVOURITE,
        ),
        // About Us
        CustomDrawerTile(
          icon: Icons.info_outline,
          title: 'About Us',
          routeName: Routes.ABOUTUS,
        ),
        // Password Change
        CustomDrawerTile(
          icon: Icons.lock_outline,
          title: 'Password Change',
          routeName: Routes.CHANGE_PASSWORD,
        ),
        // My Vehicle
        CustomDrawerTile(
          icon: Icons.directions_car,
          title: 'My Vehicle',
          routeName:  Routes.MYVEHECLE,
        ),
        // FAQ
        CustomDrawerTile(
          icon: Icons.help_outline,
          title: 'FAQ',
          routeName: Routes.FAQ,
        ),
        // Create a Mechanic Account
        // CustomDrawerTile(
        //   icon: Icons.person_add,
        //   title: 'Create a Mechanic Account',
        //   routeName: '',
        // ),
        // Log Out
        CustomDrawerTile(
          icon: Icons.logout,
          title: 'Log Out',
          routeName:  Routes.SIGN_IN,
          isLogout: true,
        ),
      ],
    );
  }

}