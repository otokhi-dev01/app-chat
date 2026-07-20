import 'package:get/get.dart';

import '../../../controllers/contact/add_group_controller.dart';

class AddGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddGroupController>(
          () => AddGroupController(),
      fenix: true,
    );
  }
}