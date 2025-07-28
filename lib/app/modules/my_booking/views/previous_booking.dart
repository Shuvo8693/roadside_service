import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/controllers/order_details_controller.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/price_row.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';

import '../../mechanic_order/model/order_details_model.dart';

class PreviousBooking extends StatefulWidget {
  const PreviousBooking({super.key});

  @override
  State<PreviousBooking> createState() => _PreviousBookingState();
}

class _PreviousBookingState extends State<PreviousBooking> {
  final OrderDetailsController _orderDetailsController = Get.put(OrderDetailsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _orderDetailsController.fetchOrderDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Booking'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: 10.w
        ),
        child: Obx((){
          OrderData? orderDetailItems = _orderDetailsController.orderDetailResponse.value.data;
          return ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mechanic Image and Name Section
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0.r),
                    child: CustomNetworkImage(imageUrl:orderDetailItems?.result?.mechanic?.image??'', // Replace with your image path
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
                        //Name
                        Text(
                          orderDetailItems?.result?.mechanic?.name??'',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Vehicle Mechanic',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        // Rating
                        SizedBox(height: 8.h),
                        InkWell(
                          onTap: (){
                            Get.toNamed(Routes.RATINGANDREVIEW,arguments: {"mechanicId":orderDetailItems?.result?.mechanic?.id});
                          },
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.orangeAccent, size: 22),
                              SizedBox(width: 4.h),
                              Text(
                                '${orderDetailItems?.result?.mechanic?.rating??'0'}/5',
                                style: GoogleFontStyles.h4(color:  AppColors.primaryColor),
                              ),
                              Icon(Icons.keyboard_arrow_right_outlined, color:  AppColors.primaryColor, size: 20),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Experience: ${orderDetailItems?.result?.mechanic?.experience??'0'} Years',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Mechanic Description
              Text(orderDetailItems?.result?.mechanic?.bio??'',
                style: TextStyle(fontSize: 13,color: Colors.grey),
              ),
              SizedBox(height: 20.h),
              ///Order_detail_section
              Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(orderDetailItems?.result?.uniqueOrderId ??'', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16.h),
              Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${orderDetailItems?.result?.address??''}\n${orderDetailItems?.result?.streetNo??''}', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailColumn('Vehicle Model', orderDetailItems?.result?.vehicle?.model??''),
                  _buildDetailColumn('Vehicle Brand', orderDetailItems?.result?.vehicle?.brand??''),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailColumn('Vehicle Number', orderDetailItems?.result?.vehicle?.number??''),
                  _buildDetailColumn('Payment', orderDetailItems?.result?.payment??''),
                ],
              ),
              SizedBox(height: 16.h),
              Text('Additional Note', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(orderDetailItems?.result?.additionalNotes??'', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16.h),
              Text('Price Summary', style: TextStyle(fontWeight: FontWeight.bold)),
              /// Towing Service Row
              ...List.generate(orderDetailItems?.mechanicServiceRate?.services?.length??0, (int index){
                final serviceItem = orderDetailItems?.mechanicServiceRate?.services?[index];
                return PriceRow(title:serviceItem?.service?.name??'',amount: '\$${serviceItem?.price.toString()??''}');
              }),
              PriceRow(title: 'Service charge', amount: '\$${orderDetailItems?.appService??''}'),
              /// Divider
              Divider(),
              /// Total Row
              PriceRow(title: 'Total', amount: '\$${orderDetailItems?.result?.total.toString()??''}', isTotal: true),

              SizedBox(height: 100.h),
            ],
          );
        }

        ),
      ),
    );
  }
  Widget _buildDetailColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
