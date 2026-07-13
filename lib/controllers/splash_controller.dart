import 'dart:async';

import 'package:get/get.dart';

import '../route/app_route.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();

    _timer = Timer(
      const Duration(seconds: 3),
      _openNextScreen,
    );
  }

  void _openNextScreen() {
    // TODO: Check access token or saved session here.
    final bool isLoggedIn = false;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}