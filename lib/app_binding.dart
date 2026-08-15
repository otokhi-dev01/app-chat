import 'package:appchat/services/auth_service%20/auth_api_service.dart';
import 'package:appchat/services/auth_service%20/auth_service.dart';
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

    // 4. Register ProfileController
    Get.lazyPut<ProfileController>(
          () => ProfileController(authApiService: Get.find<UserApiService>()),
    );
  }
}