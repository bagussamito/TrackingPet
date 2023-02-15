import 'package:get/get.dart';

import '../controllers/setting_admin_controller.dart';

class SettingAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingAdminController>(
      () => SettingAdminController(),
    );
  }
}
