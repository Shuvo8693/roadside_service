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


class MyBookingView extends StatefulWidget {
  const MyBookingView({super.key});

  @override
  State<MyBookingView> createState() => _MyBookingViewState();
}

class _MyBookingViewState extends State<MyBookingView> {
 List<Map<String,dynamic>> bookingStatus = [
   {
     'status':'pending'
   } ,
   {
     'status':'completed'
   },
   {
     'status':'canceled'
   }
 ];
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
        itemCount: bookingStatus.length,
          padding: EdgeInsets.all(10.sp),
          itemBuilder: (context,index){
          final bookingStatusIndex= bookingStatus[index];
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
              switch(bookingStatusIndex['status']) {
                  case 'pending':
                  Get.toNamed(Routes.ORDERTRACKING);
                  break;
                  case 'completed' || 'canceled':
                  Get.toNamed(Routes.PREVIOUSBOOKING);
                  break;
                default :
                  Get.toNamed(Routes.PREVIOUSBOOKING);
              }



            },
            status: bookingStatusIndex['status'],
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
            SizedBox(height: 16.h),
            CustomButton(
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return ReviewRatingDialog();
                });
              }, text: 'Pay Now',
            ),
          ],

        );
      }),
    );
  }
}
