import 'package:get/get.dart';

import '../controllers/updatebarang_controller.dart';

class UpdatebarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdatebarangController>(
      () => UpdatebarangController(),
    );
  }
}
