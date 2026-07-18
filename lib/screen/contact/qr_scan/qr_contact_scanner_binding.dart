import 'package:get/get.dart';

import '../../../controllers/contact/qr_contact_scanner_controller.dart';
import '../../../route/app_route.dart';
import '../../../services/contact_service.dart';
import '../../../services/mock/mock_app_user_service.dart';
import '../../../services/mock/mock_contact_service.dart';
import '../../../services/user_service.dart';

class QrContactScannerBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Register global services if they aren't registered yet
    if (!Get.isRegistered<AppUserService>()) {
      Get.lazyPut<AppUserService>(() => MockAppUserService(), fenix: true);
    }

    if (!Get.isRegistered<ContactService>()) {
      Get.lazyPut<ContactService>(() => MockContactService(), fenix: true);
    }

    // 2. USE Get.lazyPut for the controller so GetX links it to this route [1]
    Get.lazyPut<QrContactScannerController>(
          () => QrContactScannerController(
        appUserService: Get.find<AppUserService>(),
        contactService: Get.find<ContactService>(),
      ),
    );
  }

  /// Use this to open the scanner anywhere in your app [1].
  static Future<T?> open<T>() async {
    return Get.toNamed<T>(AppRoutes.qrScanner);
  }
}