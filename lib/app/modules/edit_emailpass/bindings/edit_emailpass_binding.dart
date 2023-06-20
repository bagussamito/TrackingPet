import 'package:get/get.dart';

import '../controllers/edit_emailpass_controller.dart';

class EditEmailpassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditEmailpassController>(
      () => EditEmailpassController(),
    );
  }
}
