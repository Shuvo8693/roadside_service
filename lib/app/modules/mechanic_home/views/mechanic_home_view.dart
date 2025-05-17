import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/widgets/active_orederAndPayment_card.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/widgets/mechanic_custom_appbar.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/widgets/metrics_card.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_outlinebutton.dart';


class MechanicHomeView extends StatelessWidget {
  const MechanicHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomMenu(0),
      appBar: MechanicAppBar(avatarUrl: AppConstants.demoPersonImage, name: 'Shuvo', title: 'Mechanic',),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 650.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Choose Service Area button
                CustomOutlineButton(
                  height: 48.h,
                    onTap: (){
                    Get.toNamed(Routes.MAP_SERVICE_AREA);
                    },
                    text: 'Choose Service Area'),

                SizedBox(height: 16.h),
                /// Active Order and Payment row
                Row(
                  children: [
                   // Active Order
                    Expanded(
                      child: ActiveOrderAndPaymentCard(text: 'Active Order',
                        icon: Icons.assignment,
                        isShowStatus: true,
                        statusCount: 5,),
                    ),
                    // Payment
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ActiveOrderAndPaymentCard(
                        text: 'Payment', icon: Icons.payment,),
                    ),
                  ],
                ),

                /// Complete order, earnings, withdraw
                SizedBox(height: 16.h),
                Row(
                  children: [
                    MetricsCard(
                      value: '14',
                      title: 'Complete Order',
                      backgroundColor: Colors.blue,
                      textColor: Colors.grey[800]!,
                    ),
                    SizedBox(width: 10.w),
                    MetricsCard(
                      value: '\$5614',
                      title: 'Total Earnings',
                      backgroundColor: Colors.blue,
                      textColor: Colors.grey[800]!,
                    ),
                    SizedBox(width: 10.w),
                    MetricsCard(
                      value: '\$314',
                      title: 'Total Withdraw',
                      backgroundColor: Colors.blue,
                      textColor: Colors.grey[800]!,
                    ),
                  ],
                ),

                /// Service Offered label
                SizedBox(height: 24.h),
                Text(
                  'Service Offered',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 16.h),

                /// Services grid
                Expanded(
                  child: _buildServicesGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildServicesGrid() {
    List<Map<String, dynamic>> serviceCategories = [
      {'category': 'Towing', 'icon': AppIcons.towingIcon},
      {'category': 'Lockout', 'icon': AppIcons.lockoutIcon},
      {'category': 'Jump Start', 'icon': AppIcons.jumpStartServiceIcon},
      {'category': 'Flat Tire Repair', 'icon': AppIcons.flatTireIcon},
      {'category': 'Gasoline Delivery', 'icon': AppIcons.gasolineIcon},
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.8,
      ),
      itemCount: serviceCategories.length,
      itemBuilder: (context, index) {
        final category = serviceCategories[index];
        return ServiceCategoryContainer(
          category: category['category'],
          icon: category['icon'],
          price: '\$60',
        );
      },
    );
  }
}

