import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/home/widgets/service_category_container.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/price_row.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';

class PreviousBooking extends StatefulWidget {
  const PreviousBooking({super.key});

  @override
  State<PreviousBooking> createState() => _PreviousBookingState();
}

class _PreviousBookingState extends State<PreviousBooking> {
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
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontSize: 18,
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
            SizedBox(height: 20.h),

            // Mechanic Description
            Text('A car mechanic is a skilled professional who specializes in diagnosing, repairing, and maintaining vehicles. '
                'They are trained to work with various car models and perform a wide range of tasks, from routine maintenance like '
                'oil changes and brake inspections.',
              style: TextStyle(fontSize: 13,color: Colors.grey),
            ),
            SizedBox(height: 20.h),
            ///Order_detail_section
            Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('#89988788', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16.h),
            Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('123 Main Street, London', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn('Vehicle Model', 'Maruti'),
                _buildDetailColumn('Vehicle Brand', 'Suzuki'),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn('Vehicle Number', '12-22-11'),
                _buildDetailColumn('Payment', 'Online'),
              ],
            ),
            SizedBox(height: 16.h),
            Text('Additional Note', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Please check the tire pressure.', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16.h),
            Text('Price Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            /// Towing Service Row
            PriceRow(title: 'Towing Service',amount:  '\$60'),
            /// Service Charge Row
            PriceRow(title: 'Service Charge',amount:  '\$10'),
            /// Divider
            Divider(),
            /// Total Row
            PriceRow(title: 'Total', amount: '\$70', isTotal: true),
            SizedBox(height: 100.h),
          ],
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
