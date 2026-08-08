import 'package:get/get.dart';

import '../../../controllers/profile/delete_account_controller.dart';
import '../../../services/auth_service /auth_service.dart';


class DeleteAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteAccountController>(
          () => DeleteAccountController(
        authService: Get.find<AuthService>(),
      ),
    );
  }
}