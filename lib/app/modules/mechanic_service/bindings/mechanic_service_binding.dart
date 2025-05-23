import 'package:get/get.dart';

import '../controllers/mechanic_service_controller.dart';

class MechanicServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MechanicServiceController>(
      () => MechanicServiceController(),
    );
  }
}
