import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/my_booking/controllers/booking_controller.dart';
import 'package:roadside_assistance/app/modules/my_booking/model/order_booking_response_model.dart';

import 'package:roadside_assistance/app/modules/my_booking/widgets/my_booking_card.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/price_row.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/rating.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';


class MyBookingView extends StatefulWidget {
  const MyBookingView({super.key});

  @override
  State<MyBookingView> createState() => _MyBookingViewState();
}

class _MyBookingViewState extends State<MyBookingView> {
  final MyBookingController _myBookingController = Get.put(MyBookingController());
 List<Map<String,dynamic>> bookingStatus = [
   {
     'status':'processing'
   } ,
   {
     'status':'completed'
   },
   {
     'status':'canceled'
   }
 ];

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _myBookingController.fetchBookings();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: Obx((){
        List<OrderData>? orderDataList= _myBookingController.orderResponseModel.value.data;
         if(_myBookingController.isLoading.value){
           return Center(child: CustomPageLoading());
         }
         if(orderDataList?.isEmpty==true){
           return Center(child: Text('No bookings are available here'));
         }
        return ListView.builder(
            itemCount: orderDataList?.length,
            padding: EdgeInsets.all(10.sp),
            itemBuilder: (context,index){
              final bookingStatusIndex = orderDataList![index];

              return  ExpansionTile(
                showTrailingIcon: false,
                maintainState: true,
                shape: Border.symmetric(vertical: BorderSide.none),
                tilePadding: EdgeInsets.all(1),
                title:  MyBookingCard(
                  name: bookingStatusIndex.mechanic?.name??'',
                  title: 'Mechanic',
                  rating: bookingStatusIndex.rating ?? 0.0,
                  imageUrl: bookingStatusIndex.mechanic?.image??'',
                  onTap: (){
                    switch(bookingStatusIndex.status) {
                      case 'processing':
                        Get.toNamed(Routes.ORDERTRACKING);
                        break;
                      case 'completed' || 'cancelled':
                        Get.toNamed(Routes.PREVIOUSBOOKING);
                        break;
                      default :
                        Get.toNamed(Routes.PREVIOUSBOOKING);
                    }
                  },
                  status: bookingStatusIndex.status??'',
                ),
                children: [
                  /// Towing Service Row
                  ...List.generate(bookingStatusIndex.serviceRates!.length, (int index){
                     final  serviceRate = bookingStatusIndex.serviceRates![index];
                    return PriceRow(title: serviceRate.name??'',amount: '\$${serviceRate.price}');
                  }),
                  /// Divider
                  Divider(),
                  /// Total Row
                  PriceRow(title: 'Total', amount: '\$${bookingStatusIndex.total}', isTotal: true),

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
            });
      }

      ),
    );
  }
}
