import 'package:get/get.dart';

import '../controllers/barang_admin_controller.dart';

class BarangAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarangAdminController>(
      () => BarangAdminController(),
    );
  }
}
