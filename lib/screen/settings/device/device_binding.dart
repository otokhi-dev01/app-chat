import 'package:get/get.dart';

import '../../../controllers/device/device_controller.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service /auth_api_service.dart';
import '../../../services/device_service/device_identity_service.dart';
import '../../../services/device_service/device_session_api_service.dart';

class DeviceBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DeviceIdentityService>()) {
      Get.lazyPut<DeviceIdentityService>(
        () => DeviceIdentityService(),
      );
    }

    if (!Get.isRegistered<DeviceSessionApiService>()) {
      Get.lazyPut<DeviceSessionApiService>(
        () => DeviceSessionApiService(
          apiService: Get.find<ApiService>(),
          authApiService: Get.find<AuthApiService>(),
          identityService: Get.find<DeviceIdentityService>(),
        ),
      );
    }

    if (!Get.isRegistered<DeviceSessionController>()) {
      Get.lazyPut<DeviceSessionController>(
            () => DeviceSessionController(
          deviceSessionApiService:
          Get.find<DeviceSessionApiService>(),
        ),
      );
    }
  }
}