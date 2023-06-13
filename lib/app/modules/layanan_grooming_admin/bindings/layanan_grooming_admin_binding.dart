import 'package:get/get.dart';

import '../controllers/layanan_grooming_admin_controller.dart';

class LayananGroomingAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayananGroomingAdminController>(
      () => LayananGroomingAdminController(),
    );
  }
}
