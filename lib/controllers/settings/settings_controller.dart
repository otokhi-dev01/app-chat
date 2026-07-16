import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppLanguage {
  english,
  khmer,
}

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  final Rx<AppLanguage> language = AppLanguage.english.obs;

  final RxString userName = 'John Doe'.obs;
  final RxString userPhone = '+1 555 000 1234'.obs;
  final RxString userEmail = 'john@example.com'.obs;


  // Profile information
  final RxString userUsername = '@johndoe'.obs;
  final RxString userBio = 'Available'.obs;


  Locale get currentLocale {
    switch (language.value) {
      case AppLanguage.english:
        return const Locale('en', 'US');

      case AppLanguage.khmer:
        return const Locale('km', 'KH');
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;

    // Immediately update the application theme.
    Get.changeThemeMode(mode);
  }

  void changeLanguage(AppLanguage selectedLanguage) {
    language.value = selectedLanguage;

    // Immediately rebuild all widgets using `.tr`.
    Get.updateLocale(currentLocale);
  }

  void updateName(String value) {
    final newValue = value.trim();

    if (newValue.isNotEmpty) {
      userName.value = newValue;
    }
  }

  void updatePhone(String value) {
    final newValue = value.trim();

    if (newValue.isNotEmpty) {
      userPhone.value = newValue;
    }
  }

  void updateEmail(String value) {
    final newValue = value.trim();

    if (newValue.isNotEmpty && GetUtils.isEmail(newValue)) {
      userEmail.value = newValue;
    }
  }

  void updateUsername(String value) {
    final String newValue = value.trim();

    if (newValue.isEmpty) {
      return;
    }

    userUsername.value = newValue.startsWith('@')
        ? newValue
        : '@$newValue';
  }

  void updateBio(String value) {
    userBio.value = value.trim();
  }

  Future<void> logout() async {
    // Clear access token, refresh token, and session data here.

    await Get.offAllNamed('/login');
  }
}