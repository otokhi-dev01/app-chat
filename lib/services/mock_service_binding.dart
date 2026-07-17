import 'package:appchat/services/save_message_service.dart';
import 'package:appchat/services/user_service.dart';
import 'package:get/get.dart';
import 'chat_list_service.dart';
import 'contact_service.dart';
import 'message_service.dart';
import 'mock_app_user_service.dart';
import 'mock_chat_list_service.dart';
import 'mock_contact_service.dart';
import 'mock_message_service.dart';
import 'mock_saved_message_service.dart';

class MockServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppUserService>(
          () => MockAppUserService(),
      fenix: true,
    );

    Get.lazyPut<ContactService>(
          () => MockContactService(),
      fenix: true,
    );

    Get.lazyPut<ChatListService>(
          () => MockChatListService(),
      fenix: true,
    );

    Get.lazyPut<MessageService>(
          () => MockMessageService(),
      fenix: true,
    );

    Get.lazyPut<SavedMessageService>(
          () => MockSavedMessageService(
        messageService:
        Get.find<MessageService>(),
      ),
      fenix: true,
    );
  }
}