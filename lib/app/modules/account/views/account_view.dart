import 'package:flutter/material.dart';
import 'package:roadside_assistance/app/modules/account/widgets/mechanic_tile.dart';
import 'package:roadside_assistance/app/modules/account/widgets/user_tile.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/prefs_helper/prefs_helpers.dart'; // Adjust based on your routes

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await getRole();
    });
  }

  getRole() async {
    String? roleUser = await PrefsHelper.getString('role');
    setState(() {
      userRole = roleUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(3),
      appBar: AppBar(
        title: Text('Account', style: GoogleFontStyles.h2()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: userRole == 'user'
              ? UserTile()
              : userRole == 'mechanic'
              ? MechanicTile()
              : SizedBox.shrink(),
    );
  }
}
