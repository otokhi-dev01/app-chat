import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../controllers/contact/contact_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../services/chat_data_service.dart';
import '../../services/chat_list_service.dart';
import '../../services/contact_service.dart';
import '../../services/mock/mock_chat_service.dart';
import '../../services/mock/mock_contact_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChatDataService>()) {
      Get.lazyPut<ChatDataService>(
            () => MockChatDataService(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ChatController>()) {
      Get.lazyPut<ChatController>(
            () => ChatController(
          chatService: Get.find<ChatListService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ContactService>()) {
      Get.lazyPut<ContactService>(
            () => MockContactService(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ContactController>()) {
      Get.lazyPut<ContactController>(
            () => ContactController(
          contactService: Get.find<ContactService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(
            () => SettingsController(),
        fenix: true,
      );
    }
  }
}