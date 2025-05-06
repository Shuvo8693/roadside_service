import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:roadside_assistance/app/modules/my_booking/widgets/my_booking_card.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/price_row.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/rating.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';


class MyBookingView extends StatelessWidget {
  const MyBookingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 3,
          padding: EdgeInsets.all(10),
          itemBuilder: (context,index){
        return  ExpansionTile(
          showTrailingIcon: false,
          maintainState: true,
          shape: Border.symmetric(vertical: BorderSide.none),
          tilePadding: EdgeInsets.all(1),
          title:  MyBookingCard(
            name: 'Marley',
            title: 'Mechanic',
            rating: 2.5,
            imageUrl: AppConstants.mechanicImage,
            onTap: (){
              Get.toNamed(Routes.ORDERTRACKING);
            },
            status: 'completed',
          ),
          children: [
            /// Towing Service Row
            PriceRow(title: 'Towing Service',amount:  '\$60'),
            /// Service Charge Row
            PriceRow(title: 'Service Charge',amount:  '\$10'),
            /// Divider
            Divider(),
            /// Total Row
            PriceRow(title: 'Total', amount: '\$70', isTotal: true),

            // Pay Now Button
            SizedBox(height: 16),
            CustomButton(onTap: (){
                  ReviewRatingDialog();
                }, text: 'Pay Now'),
          ],

        );
      }),
    );
  }
}
