import 'package:get/get.dart';

import '../../../controllers/settings/data_storage_controller.dart';

class DataStorageBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DataStorageController>()) {
      Get.lazyPut<DataStorageController>(
            () => DataStorageController(),
      );
    }
  }
}