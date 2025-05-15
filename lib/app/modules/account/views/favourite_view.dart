import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_providere_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0.sp),
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ServiceProviderCard(
              name: 'Shuvo',
              title: 'Mechanic',
              distance: '1000 km',
              rating: 4.5,
              time: '30 min',
              imageUrl: AppConstants.mechanicImage,
              isFavourite: true,
              onTap: () {
                Get.toNamed(Routes.MECHANICDETAILS);
              },
            );
          },
        ),
      ),
    );
  }
}
