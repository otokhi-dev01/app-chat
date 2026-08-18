import 'package:get/get.dart';

import '../../../controllers/contact/add_group_controller.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service /auth_api_service.dart';
import '../../../services/chat_service/group_chat_api_service.dart';

class AddGroupBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GroupChatApiService>()) {
      Get.lazyPut<GroupChatApiService>(
        () => GroupChatApiService(
          apiService: Get.find<ApiService>(),
          authApiService: Get.find<AuthApiService>(),
        ),
      );
    }

    Get.lazyPut<AddGroupController>(
      () => AddGroupController(
        groupChatApiService: Get.find<GroupChatApiService>(),
      ),
      fenix: true,
    );
  }
}