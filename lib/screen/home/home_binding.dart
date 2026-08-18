import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../controllers/contact/contact_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../services/chat_service/chat_list_api_service.dart';
import '../../services/massage_service /chat_list_service.dart';
import '../../services/contact_service/contact_api_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChatListService>()) {
      Get.lazyPut<ChatListService>(
        () => Get.find<ChatListApiService>(),
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

    if (!Get.isRegistered<ContactController>()) {
      Get.lazyPut<ContactController>(
            () => ContactController(
          contactApiService: Get.find<ContactApiService>(),
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