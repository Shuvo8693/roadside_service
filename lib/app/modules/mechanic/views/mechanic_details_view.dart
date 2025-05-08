import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/data/api_constants.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';


class MechanicDetailsView extends StatefulWidget {
  const MechanicDetailsView({super.key});

  @override
  State<MechanicDetailsView> createState() => _MechanicDetailsViewState();
}

class _MechanicDetailsViewState extends State<MechanicDetailsView> {
  List<Map<String, dynamic>> serviceCategories = [
    {'category': 'Towing', 'icon': AppIcons.towingIcon},
    {'category': 'Lockout', 'icon': AppIcons.lockoutIcon},
    {'category': 'Jump Start', 'icon': AppIcons.jumpStartServiceIcon},
    {'category': 'Flat Tire Repair', 'icon': AppIcons.flatTireIcon},
    {'category': 'Gasoline Delivery', 'icon': AppIcons.gasolineIcon},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanic Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mechanic Image and Name Section
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0.r),
                  child: CustomNetworkImage(imageUrl:AppConstants.mechanicImage, // Replace with your image path
                    width: 110.h,
                    height: 110.h,
                    boxFit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Darrell Steward ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Car Mechanic',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      InkWell(
                        onTap: (){
                          Get.toNamed(Routes.RATINGANDREVIEW);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.orangeAccent, size: 22),
                            SizedBox(width: 4.h),
                            Text(
                              '4.8/5',
                              style: GoogleFontStyles.h4(color:  AppColors.primaryColor),
                            ),
                            Icon(Icons.keyboard_arrow_right_outlined, color:  AppColors.primaryColor, size: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Experience: 2 Years',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Mechanic Description
            Text('A car mechanic is a skilled professional who specializes in diagnosing, repairing, and maintaining vehicles. '
                  'They are trained to work with various car models and perform a wide range of tasks, from routine maintenance like '
                  'oil changes and brake inspections.',
              style: TextStyle(fontSize: 13,color: Colors.grey),
            ),
            SizedBox(height: 20.h),

            // Service Section Title
            Text(
              'Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),

            // Service Options in Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  ...serviceCategories.asMap().map((index, category) {
                    return MapEntry(index,
                      GestureDetector(
                        onTap: (){
                          print(category['category']);
                        },
                        child: ServiceCategoryContainer(
                          category: category['category'],
                          icon: category['icon'],
                          isActiveBooking: true,
                          price: '\$60',
                          bookNowOnTap: (){
                            Get.toNamed(Routes.CHECK_OUT);
                          },
                        ),
                      ),
                    );
                  }).values,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

