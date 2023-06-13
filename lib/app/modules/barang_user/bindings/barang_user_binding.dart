import 'package:get/get.dart';

import '../controllers/barang_user_controller.dart';

class BarangUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarangUserController>(
      () => BarangUserController(),
    );
  }
}
