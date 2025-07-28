import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/price_row.dart';
import 'package:roadside_assistance/common/widgets/bottomSheet_top_line.dart';

import '../../mechanic_order/model/order_details_model.dart';

class BottomSheetOrderDetails extends StatelessWidget {
 final OrderData orderDetailItems;
   const BottomSheetOrderDetails({
    super.key, required this.orderDetailItems
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 1,
      builder: (context, scrollController) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
            ),
          ],
        ),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: BottomSheetTopLine(),
            ),
            SizedBox(height: 12.h),
            Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(orderDetailItems.result?.uniqueOrderId ??'', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16.h),
            Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${orderDetailItems.result?.address??''}\n${orderDetailItems.result?.streetNo??''}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn('Vehicle Model', orderDetailItems.result?.vehicle?.model??''),
                _buildDetailColumn('Vehicle Brand', orderDetailItems.result?.vehicle?.brand??''),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn('Vehicle Number', orderDetailItems.result?.vehicle?.number??''),
                _buildDetailColumn('Payment', orderDetailItems.result?.payment??''),
              ],
            ),
            SizedBox(height: 16.h),
            Text('Additional Note', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(orderDetailItems.result?.additionalNotes??'', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16.h),
            Text('Price Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            /// Towing Service Row
            ...List.generate(orderDetailItems.mechanicServiceRate?.services?.length??0, (int index){
              final serviceItem = orderDetailItems.mechanicServiceRate?.services?[index];
              return PriceRow(title:serviceItem?.service?.name??'',amount: '\$${serviceItem?.price.toString()??''}');
            }),
            PriceRow(title: 'Service charge', amount: '\$${orderDetailItems.appService??''}'),
            /// Divider
            Divider(),
            /// Total Row
            PriceRow(title: 'Total', amount: '\$${orderDetailItems.result?.total.toString()??''}', isTotal: true),
            SizedBox(height: 100.h), // space for buttons
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