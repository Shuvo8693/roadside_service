import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';
import 'package:roadside_assistance/main.dart';

import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashController splashController = Get.put(SplashController());
  double _scale = 4.4.sp;

  @override
  void initState() {
    super.initState();
    logoScaling();
  }

  void logoScaling() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _scale = 1.1.sp;
      });
      Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
        authenticationRoute();
      });
    });
  }

  authenticationRoute() {
    if (token.isNotEmpty) {
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AnimatedScale(
        scale: _scale,
        duration: Duration(seconds: 1),
        child: Center(child: SvgPicture.asset(AppImage.appLogoImg)),
      ),
    );
  }
}
