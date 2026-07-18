import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppLanguage {
  english,
  khmer,
}

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;

  final Rx<ThemeMode> themeMode =
      ThemeMode.system.obs;

  final RxString userName =
      'John Doe'.obs;

  final RxString userPhone =
      '+1 555 000 1234'.obs;

  final RxString userEmail =
      'john@example.com'.obs;

  final RxString userUsername =
      '@johndoe'.obs;

  final RxString userBio =
      'Available'.obs;

  bool _isChangingLanguage = false;

  AppLanguage get currentLanguage {
    Locale? locale =
        Get.locale ?? Get.deviceLocale;

    String languageCode =
        locale?.languageCode ?? 'en';

    if (languageCode == 'km') {
      return AppLanguage.khmer;
    }

    return AppLanguage.english;
  }

  Locale get currentLocale {
    return _localeFromLanguage(
      currentLanguage,
    );
  }

  Locale _localeFromLanguage(
      AppLanguage selectedLanguage,
      ) {
    switch (selectedLanguage) {
      case AppLanguage.english:
        return Locale(
          'en',
          'US',
        );

      case AppLanguage.khmer:
        return Locale(
          'km',
          'KH',
        );
    }
  }

  void toggleNotifications(
      bool value,
      ) {
    if (notificationsEnabled.value ==
        value) {
      return;
    }

    notificationsEnabled.value = value;
  }

  void changeTheme(
      ThemeMode mode,
      ) {
    if (themeMode.value == mode) {
      return;
    }

    themeMode.value = mode;

    Get.changeThemeMode(
      mode,
    );
  }

  Future<void> changeLanguage(
      AppLanguage selectedLanguage,
      ) async {
    if (_isChangingLanguage ||
        selectedLanguage ==
            currentLanguage) {
      return;
    }

    _isChangingLanguage = true;

    try {
      Locale locale =
      _localeFromLanguage(
        selectedLanguage,
      );

      await Get.updateLocale(
        locale,
      );
    } finally {
      _isChangingLanguage = false;
    }
  }

  void updateName(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty ||
        newValue == userName.value) {
      return;
    }

    userName.value = newValue;
  }

  void updatePhone(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty ||
        newValue == userPhone.value) {
      return;
    }

    userPhone.value = newValue;
  }

  void updateEmail(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty ||
        newValue == userEmail.value ||
        !GetUtils.isEmail(newValue)) {
      return;
    }

    userEmail.value = newValue;
  }

  void updateUsername(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty) {
      return;
    }

    String normalizedUsername =
    newValue.startsWith('@')
        ? newValue
        : '@$newValue';

    if (normalizedUsername ==
        userUsername.value) {
      return;
    }

    userUsername.value =
        normalizedUsername;
  }

  void updateBio(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue ==
        userBio.value) {
      return;
    }

    userBio.value = newValue;
  }

  Future<void> logout() async {
    await Get.offAllNamed(
      '/login',
    );
  }
}