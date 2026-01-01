import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/notification/controllers/notification_controller.dart';
import 'package:roadside_assistance/app/modules/notification/widgets/notification_card.dart';
import 'package:roadside_assistance/common/date_time_formation/data_age_formation.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_loading.dart';

import '../model/notification_response.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController _notificationController = Get.put(
    NotificationController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _notificationController.fetchNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), centerTitle: true),
      body: Obx(() {
        List<NotificationItem> notificationItems = _notificationController.notificationResponse.value.data?.notifications??[];
        if(_notificationController.isLoading.value){
          return Center(child: CustomLoading());
        } else if(notificationItems.isEmpty){
          return Center(child: Text('Notification is empty'));
        }
        return ListView.builder(
          itemCount: notificationItems.length,
          itemBuilder: (context, index) {
            final notification  =  notificationItems[index];
            return NotificationTile(
              onTap: (){
               showPaymentDialog(context,notification.orderId??'');
              },
              image: 'Disabled now',
              title: notification.msg??'',
              subtitle: 'Tap to complete order' ,
              time: DateAgeFormation().formatAge(notification.createdAt??DateTime.now()),
            );
          },
        );
      }),
    );
  }
  void showPaymentDialog(BuildContext context, String orderId) {

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Order',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text('Amount: \$29.99'),
              SizedBox(height: 16.h),
              Text('Do you want to proceed with this order confirmation?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Obx((){
              return  CustomButton(
                loading: _notificationController.isLoading2.value,
                width: 100.w,
                height: 40.h,
                onTap: () async {
                  await _notificationController.makePayment(orderId: orderId,callBack: () {
                    Navigator.of(context).pop();
                  });
                },
                text: 'Confirm',
              );
             }
            ),
          ],
        );
      },
    );
  }


}
