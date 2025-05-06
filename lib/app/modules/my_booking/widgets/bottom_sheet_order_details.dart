import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/price_row.dart';
import 'package:roadside_assistance/common/widgets/bottomSheet_top_line.dart';

class BottomSheetOrderDetails extends StatelessWidget {
  const BottomSheetOrderDetails({
    super.key,
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
            SizedBox(height: 12),
            Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('#89988788', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('123 Main Street, London', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn('Vehicle Model', 'Maruti'),
                _buildDetailColumn('Vehicle Brand', 'Suzuki'),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn('Vehicle Number', '12-22-11'),
                _buildDetailColumn('Payment', 'Online'),
              ],
            ),
            SizedBox(height: 16),
            Text('Additional Note', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Please check the tire pressure.', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text('Price Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            /// Towing Service Row
            PriceRow(title: 'Towing Service',amount:  '\$60'),
            /// Service Charge Row
            PriceRow(title: 'Service Charge',amount:  '\$10'),
            /// Divider
            Divider(),
            /// Total Row
            PriceRow(title: 'Total', amount: '\$70', isTotal: true),
            SizedBox(height: 100), // space for buttons
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