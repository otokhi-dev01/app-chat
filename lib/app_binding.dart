import 'package:appchat/services/auth_service%20/auth_api_service.dart';
import 'package:appchat/services/chat_service/chat_list_api_service.dart';
import 'package:appchat/services/contact_service/contact_api_service.dart';
import 'package:appchat/services/folder_service/chat_folder_api_service.dart';
import 'package:appchat/services/massage_service%20/message_api_service.dart';// Fixed 'massage' to 'message' if that was a typo
import 'package:appchat/services/user_service/user_service.dart';
import 'package:get/get.dart';

import 'controllers/profile/profile_controller.dart';
import 'services/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Register the base ApiService
    Get.put<ApiService>(ApiService(), permanent: true);

    // 2. Register AuthApiService
    Get.put<AuthApiService>(
      AuthApiService(apiService: Get.find<ApiService>()),
      permanent: true,
    );

    // 3. Register UserApiService (depends on AuthApiService)
    Get.put<UserApiService>(
      UserApiService(
        apiService: Get.find<ApiService>(),
        authApiService: Get.find<AuthApiService>(),
      ),
      permanent: true,
    );

    // 4. Register ChatFolderApiService
    Get.put<ChatFolderApiService>(
      ChatFolderApiService(
        apiService: Get.find<ApiService>(),
        authApiService: Get.find<AuthApiService>(),
        userApiService: Get.find<UserApiService>(),
      ),
      permanent: true,
    );

    // 5. Register ContactApiService
    Get.put<ContactApiService>(
      ContactApiService(
        apiService: Get.find<ApiService>(),
        authApiService: Get.find<AuthApiService>(),
      ),
      permanent: true,
    );

    // 6. Register ChatListApiService
    Get.put<ChatListApiService>(
      ChatListApiService(
        apiService: Get.find<ApiService>(),
        authApiService: Get.find<AuthApiService>(),
      ),
      permanent: true,
    );

    // 7. Register MessageApiService
    Get.put<MessageApiService>(
      MessageApiService(
        apiService: Get.find<ApiService>(),
        authApiService: Get.find<AuthApiService>(),
        userApiService: Get.find<UserApiService>(),
      ),
      permanent: true,
    );

    // 8. Register ProfileController (Lazy)
    Get.lazyPut<ProfileController>(
          () => ProfileController(authApiService: Get.find<UserApiService>()),
      fenix: true,
    );
  }
}