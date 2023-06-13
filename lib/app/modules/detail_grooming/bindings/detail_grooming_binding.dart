import 'package:get/get.dart';

import '../controllers/detail_grooming_controller.dart';

class DetailGroomingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailGroomingController>(
      () => DetailGroomingController(),
    );
  }
}
