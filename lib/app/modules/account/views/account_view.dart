import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(3),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('AccountView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AccountView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
