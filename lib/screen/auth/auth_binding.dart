// import 'package:get/get.dart';
//
// import '../../controllers/auth/auth_controller.dart';
//
// class AuthBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<AuthController>(
//           () => AuthController(),
//       fenix: true,
//     );
//   }
// }

import 'package:get/get.dart';

import '../../controllers/auth/login_controller.dart';
import '../../data/providers/auth_api_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());

    Get.lazyPut<AuthApiProvider>(
          () => AuthApiProvider(Get.find<ApiService>()),
    );

    Get.lazyPut<AuthRepository>(
          () => AuthRepository(Get.find<AuthApiProvider>()),
    );

    Get.lazyPut<StorageService>(() => StorageService());

    Get.lazyPut<LoginController>(
          () => LoginController(
        repository: Get.find<AuthRepository>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}