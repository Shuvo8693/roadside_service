import 'package:get/get.dart';

import '../controllers/mechanic_payment_controller.dart';

class MechanicPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MechanicPaymentController>(
      () => MechanicPaymentController(),
    );
  }
}
