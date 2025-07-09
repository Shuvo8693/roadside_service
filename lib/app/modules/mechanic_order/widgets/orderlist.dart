import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/controllers/mechanic_order_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/model/order_status_model.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/views/mechanic_order_view.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';

import 'order_card.dart';

class OrdersList extends StatefulWidget {
  final int tapIndex;
  final String status;

  const OrdersList({super.key, required this.tapIndex, required this.status});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final MechanicOrderController _mechanicOrderController = Get.put(
    MechanicOrderController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__) async {
      await _mechanicOrderController.fetchStatus(widget.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Order> ordersData = _mechanicOrderController.orderStatusModel.value.data?.orders??[];
      if(_mechanicOrderController.isLoading.value){
        return Center(child: CustomPageLoading());
      }
      if(ordersData.isEmpty==true){
        return Center(child: Text("No ${widget.status} are available"));
      }
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: ordersData.length,
        itemBuilder: (context, index) {
          final orderDataIndex = ordersData[index];
          return InkWell(
            onTap: () {
              Get.toNamed(Routes.ORDER_DETAILS);
            },
            child: OrderCard(order: orderDataIndex , tapIndex: widget.tapIndex),
          );
        },
      );
    });
  }
}
