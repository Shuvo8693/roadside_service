import 'package:get/get.dart';

import '../controllers/mechanic_order_controller.dart';

class MechanicOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MechanicOrderController>(
      () => MechanicOrderController(),
    );
  }
}
