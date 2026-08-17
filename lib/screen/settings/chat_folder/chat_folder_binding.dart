import 'package:get/get.dart';

import '../../../controllers/settings/chat_folder_controller.dart';
import '../../../services/folder_service/chat_folder_api_service.dart';

class ChatFolderBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<
        ChatFolderController>()) {
      Get.lazyPut<ChatFolderController>(
            () => ChatFolderController(
          chatFolderApiService:
          Get.find<ChatFolderApiService>(),
        ),
      );
    }
  }
}