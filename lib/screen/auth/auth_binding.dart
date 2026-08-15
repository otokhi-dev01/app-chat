import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../services/api_service.dart';
import '../../services/auth_service /auth_api_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(
          () => ApiService(),
      fenix: true,
    );

    Get.lazyPut<AuthApiService>(
          () => AuthApiService(
        apiService: Get.find<ApiService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AuthController>(
          () => AuthController(
        authApiService:
        Get.find<AuthApiService>(),
      ),
    );
  }
}

// import 'package:get/get.dart';
//
// import '../../controllers/auth/login_controller.dart';
// import '../../data/providers/auth_api_provider.dart';
// import '../../data/repositories/auth_repository.dart';
// import '../../services/api_service.dart';
// import '../../services/storage_service.dart';
//
//
// class AuthBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ApiService>(() => ApiService());
//
//     Get.lazyPut<AuthApiProvider>(
//           () => AuthApiProvider(Get.find<ApiService>()),
//     );
//
//     Get.lazyPut<AuthRepository>(
//           () => AuthRepository(Get.find<AuthApiProvider>()),
//     );
//
//     Get.lazyPut<StorageService>(() => StorageService());
//
//     Get.lazyPut<LoginController>(
//           () => LoginController(
//         repository: Get.find<AuthRepository>(),
//         storageService: Get.find<StorageService>(),
//       ),
//     );
//   }
// }