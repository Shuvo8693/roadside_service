import 'package:get/get.dart';

import '../controllers/service_controller.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingController>(
      () => MyBookingController(),
    );
  }
}
