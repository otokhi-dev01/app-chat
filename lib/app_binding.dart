import 'package:get/get.dart';

import 'services/auth_service /auth_service.dart';
import '../services/mock/mock_auth_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(
      MockAuthService(),
      permanent: true,
    );
  }
}