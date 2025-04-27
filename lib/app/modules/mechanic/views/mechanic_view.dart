import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';

import '../controllers/mechanic_controller.dart';

class MechanicView extends StatelessWidget {
  const MechanicView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(2,chooseServiceOrOrder: 'Mechanic',),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('MechanicView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MechanicView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
