import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_drawer/custom_drawer_tile.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart'; // Adjust based on your routes

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar : BottomMenu(3),
      appBar: AppBar(
        title: Text(
          'Account',
          style: GoogleFontStyles.h2(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          // My Info
          CustomDrawerTile(
            icon: Icons.person_outline,
            title: 'My Info',
            routeName: Routes.MYINFO,
          ),
          // History
          CustomDrawerTile(
            icon: Icons.history,
            title: 'History',
            routeName: '',
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
          CustomDrawerTile(
            icon: Icons.person_add,
            title: 'Create a Mechanic Account',
            routeName: '',
          ),
          // Log Out
          CustomDrawerTile(
            icon: Icons.logout,
            title: 'Log Out',
            routeName: '/login',
            isLogout: true,
          ),
        ],
      ),
    );
  }
}