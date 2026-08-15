import 'package:get/get.dart';

import '../../../controllers/contact/qr_contact_scanner_controller.dart';
import '../../../route/app_route.dart';
import '../../../services/contact_service/contact_service.dart';
import '../../../services/mock/mock_contact_service.dart';
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

    // 2. Ensure ContactService is registered (use MockContactService since ContactService is abstract)
    if (!Get.isRegistered<ContactService>()) {
      Get.lazyPut<ContactService>(() => MockContactService(), fenix: true);
    }

    // 3. Register the controller using the correct Service type
    Get.lazyPut<QrContactScannerController>(
          () => QrContactScannerController(
        appUserService: Get.find<UserApiService>(),
        contactService: Get.find<ContactService>(),
      ),
    );
  }

  static Future<T?> open<T>() async {
    return Get.toNamed<T>(AppRoutes.qrScanner);
  }
}