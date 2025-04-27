import 'package:get/get.dart';

import '../controllers/my_location_selection_controller.dart';

class MyLocationSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyLocationSelectionController>(
      () => MyLocationSelectionController(),
    );
  }
}
