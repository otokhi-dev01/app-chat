import 'package:get/get.dart';

import '../../../controllers/device/device_controller.dart';
import '../../../services/device_service/device_service.dart';
import '../../../services/device_service/real_device_service.dart';

class DeviceBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DeviceService>()) {
      Get.put<DeviceService>(
        RealDeviceService(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<DeviceController>()) {
      Get.lazyPut<DeviceController>(
            () => DeviceController(
          deviceService:
          Get.find<DeviceService>(),
        ),
      );
    }
  }
}