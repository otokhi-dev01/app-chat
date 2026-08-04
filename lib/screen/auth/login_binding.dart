// import 'package:get/get.dart';
//
// import '../../services/api_service.dart';
// import '../../services/storage_service.dart';
// import '../../data/providers/auth_api_provider.dart';
// import '../../data/repositories/auth_repository.dart';
//
// class LoginBinding extends Bindings {
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