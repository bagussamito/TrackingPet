import 'package:get/get.dart';

import '../controllers/grooming_admin_controller.dart';

class GroomingAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroomingAdminController>(
      () => GroomingAdminController(),
    );
  }
}
