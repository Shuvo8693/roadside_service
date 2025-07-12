import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/controllers/mechanic_order_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/model/order_status_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/views/mechanic_order_view.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_outlinebutton.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';
import 'package:roadside_assistance/common/widgets/status_widgets.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final int tapIndex;
  final int orderIndex;
   OrderCard({super.key, required this.order, required this.tapIndex, required this.orderIndex});

  final MechanicOrderController mechanicOrderController= Get.put(MechanicOrderController());

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
                          /// Customer name
                          Text(
                            order.user?.name??'',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          /// Order Status
                          SizedBox(width: 8.w),
                          StatusCard(status: order.status??'',borderRadius: 10,),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      /// Distance
                      Text("${order.distance} K/m Away",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                /// Total price
                Text('\$${order.total}',
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
          ...List.generate(order.services?.length??0, (int index){
           final serviceNameIndex = order.services![index];
            return  Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 4.h),
              child: Row(
                children: [
                  Text(
                    'Service ${index + 1} : ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  Text(serviceNameIndex.name??'',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
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
                Text("${order.vehicle?.brand} ${order.vehicle?.model} ${order.vehicle?.number}",
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
                  child: Obx(() {
                    return CustomOutlineButton(
                      loading: mechanicOrderController.isLoading3[orderIndex]??false,
                      height: 48.h,
                      onTap: () async {
                        await mechanicOrderController.cancelOrder(order.id ?? '',orderIndex);
                      },
                      text: 'Decline',
                      foregroundColor: Colors.redAccent,
                      borderSideColor: Colors.redAccent,
                    );
                    }

                  ),
                ),
                horizontalSpacing(8),
                Expanded(
                  child: Obx((){
                    return  CustomButton(
                        loading: mechanicOrderController.isLoading2[orderIndex]??false,
                        height: 48.h,
                        onTap: ()async{
                          await mechanicOrderController.acceptOrder(order.id??'',orderIndex);
                         },
                        text: 'Accept');
                        }

                  ),
                ),
              ],
            ),
          ),
          /// Action button for Progress
          if(tapIndex==1)
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: Obx((){
                return  CustomButton(
                  loading: mechanicOrderController.isLoading4[orderIndex]??false,
                    height: 48.h,
                    onTap: ()async{
                      await mechanicOrderController.markAsComplete(order.id??'',orderIndex);
                    }, text: 'Mark as Complete');
                   }

              ),
            )

        ],
      ),
    );
  }
}