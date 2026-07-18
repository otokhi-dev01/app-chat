import 'package:get/get.dart';

import '../../../controllers/settings/chat_folder_controller.dart';
import '../../../services/chat_folder_service.dart';
import '../../../services/mock/mock_chat_folder_service.dart';

class ChatFolderBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<
        ChatFolderService>()) {
      Get.put<ChatFolderService>(
        MockChatFolderService(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<
        ChatFolderController>()) {
      Get.lazyPut<ChatFolderController>(
            () => ChatFolderController(
          folderService:
          Get.find<ChatFolderService>(),
        ),
      );
    }
  }
}