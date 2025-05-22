import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/views/mechanic_order_view.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

import 'order_card.dart';

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  final int tapIndex;
   const OrdersList({super.key, required this.orders, required this.tapIndex});

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? Center(child: Text('No orders available'))
        : ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Get.toNamed(Routes.ORDER_DETAILS);
          }, child: OrderCard(order: orders[index], tapIndex: tapIndex,));
      },
    );
  }
}