import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';

class BottomMenu extends StatefulWidget {
  final int menuIndex;
  final String? chooseServiceOrOrder;
  final String? chooseMechanicOrPayment;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const BottomMenu(this.menuIndex, {super.key, this.chooseServiceOrOrder, this.scaffoldKey, this.chooseMechanicOrPayment});

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.menuIndex; // Set initial index
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // Prevent unnecessary re-navigation to the same screen
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to corresponding pages
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.HOME);
        break;
      case 1:
        Get.offAllNamed(Routes.SERVICE);
        break;
      case 2:
        Get.offAllNamed(Routes.MECHANIC);
        break;
      case 3:
        //widget.scaffoldKey?.currentState!.openDrawer();
        Get.offAllNamed(Routes.ACCOUNT);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: BottomNavigationBar(
          currentIndex: _selectedIndex, // Set the selected index
          onTap: _onItemTapped, // Handle taps on items
          type: BottomNavigationBarType.fixed, // Prevents shifting behavior
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryColor,
          showSelectedLabels: true,
          unselectedItemColor: Colors.grey, // Inactive item color
          showUnselectedLabels: true,
          unselectedIconTheme: IconThemeData(color: Colors.black),
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          items: [
            _buildBottomNavItem(AppIcons.homesIcon, 'Home'),
            _buildBottomNavItem(AppIcons.bookingIcon, 'My Booking'),
            _buildBottomNavItem(AppIcons.mechanicIcon, 'Mechanic'),
            _buildBottomNavItem(AppIcons.profile1Icon, 'Account'),
          ],
        ),
    );

  }

  BottomNavigationBarItem _buildBottomNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        height: 28.0.h,
        width: 28.0.w,
        colorFilter: const ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn), // Inactive icon color
      ),
      activeIcon: SvgPicture.asset(
        iconPath,
        height: 30.0.h,
        width: 30.0.w,
        colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn), // Active icon color
      ),
      label: label,
    );
  }
}
