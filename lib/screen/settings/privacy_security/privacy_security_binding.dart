import 'package:get/get.dart';

import '../../../controllers/settings/settings_privacy_security_controller.dart';

class PrivacySecurityBinding
    extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<
        PrivacySecurityController>()) {
      Get.lazyPut<
          PrivacySecurityController>(
            () => PrivacySecurityController(),
      );
    }
  }
}