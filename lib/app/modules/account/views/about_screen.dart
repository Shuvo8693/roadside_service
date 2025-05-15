import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/common/widgets/custom_appBar_title.dart';
import 'package:roadside_assistance/common/widgets/html_view.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // AboutUsController aboutUsController=Get.put(AboutUsController());

  @override
  void initState() {
    super.initState();
    //aboutUsController.fetchAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: HTMLView(htmlData: ' This is about us'),
          ),
        ],
      ),
    );
  }
}
