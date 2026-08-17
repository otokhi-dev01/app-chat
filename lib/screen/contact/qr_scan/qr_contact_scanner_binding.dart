import 'package:get/get.dart';

import '../../../controllers/contact/qr_contact_scanner_controller.dart';
import '../../../route/app_route.dart';
import '../../../services/contact_service/contact_api_service.dart';
import '../../../services/user_service/user_service.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service /auth_api_service.dart';

class QrContactScannerBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Ensure UserApiService is registered
    if (!Get.isRegistered<UserApiService>()) {
      Get.lazyPut<UserApiService>(
            () => UserApiService(
          apiService: Get.find<ApiService>(),
          authApiService: Get.find<AuthApiService>(),
        ),
        fenix: true,
      );
    }

    // 2. Register the controller
    Get.lazyPut<QrContactScannerController>(
          () => QrContactScannerController(
        appUserService: Get.find<UserApiService>(),
        contactService: Get.find<ContactApiService>(),
      ),
    );
  }

  static Future<T?> open<T>() async {
    return Get.toNamed<T>(AppRoutes.qrScanner);
  }
}