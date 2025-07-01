import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/my_booking/views/order_tracking_view.dart';

import '../controllers/booking_controller.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingController>(
      () => MyBookingController(),
    );

    Get.lazyPut<OrderTrackingView>(
      () => OrderTrackingView(),
    );
  }
}
