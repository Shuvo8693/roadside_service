import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/views/mechanic_order_view.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_outlinebutton.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';
import 'package:roadside_assistance/common/widgets/status_widgets.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final int tapIndex;
  const OrderCard({super.key, required this.order, required this.tapIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer info and status
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            order.customerName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          /// Order Status
                          SizedBox(width: 8.w),
                          StatusCard(status: order.status,borderRadius: 10,),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        order.distance,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text('\$${order.price}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Service details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Text(
                  'Service',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Spacer(),
                Text(
                  order.service,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Car type details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  'Car Type',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Spacer(),
                Text(
                  order.carType,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// Action buttons For New Order
          if(tapIndex==0)
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              children: [
                Expanded(
                  child: CustomOutlineButton(
                    height: 48.h,
                    onTap: (){}, text: 'Decline',foregroundColor: Colors.redAccent,borderSideColor:Colors.redAccent ,),
                ),
                horizontalSpacing(8),
                Expanded(
                  child: CustomButton(
                      height: 48.h,
                      onTap: (){}, text: 'Accept'),
                ),
              ],
            ),
          ),
          /// Action button for Progress
          if(tapIndex==1)
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: CustomButton(
                height: 48.h,
                  onTap: (){}, text: 'Mark as Complete'),
            )

        ],
      ),
    );
  }
}