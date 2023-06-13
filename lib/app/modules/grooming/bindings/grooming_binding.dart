import 'package:get/get.dart';

import '../controllers/grooming_controller.dart';

class GroomingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroomingController>(
      () => GroomingController(),
    );
  }
}
