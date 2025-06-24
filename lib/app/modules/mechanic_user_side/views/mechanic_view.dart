import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_providere_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';

import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_search_field.dart';


class MechanicView extends StatelessWidget {
   MechanicView({super.key});
 final TextEditingController searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(2,chooseServiceOrOrder: 'Mechanic',),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('MechanicView'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0.sp),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            CustomSearchField(
              searchCtrl: searchCtrl,
              iconOnTap: () {},
              onChanged: (value) {},
            ),
            SizedBox(height: 20.h),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ServiceProviderCard(
                  name: 'Shuvo',
                  title: 'Mechanic',
                  distance: '1000 km',
                  rating: 4.5,
                  duration: '30 min',
                  imageUrl: AppConstants.mechanicImage,
                  onTap: () {
                    Get.toNamed(Routes.MECHANICDETAILS);
                  }, favouriteTap: () {  },
                );
              },
            ),
         ],
        ),
      ),
    );
  }
}
