import 'package:get/get.dart';

import '../controllers/mechanic_home_controller.dart';

class MechanicHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MechanicHomeController>(
      () => MechanicHomeController(),
    );
  }
}
