import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route/app_route.dart';

enum AppLanguage {
  english,
  khmer,
  chinese,
}

class SettingsController extends GetxController {
  final Rx<ThemeMode> themeMode =
      ThemeMode.system.obs;

  final Rx<AppLanguage> selectedLanguage =
      AppLanguage.english.obs;

  bool _isChangingLanguage = false;

  @override
  void onInit() {
    super.onInit();

    _initializeLanguage();
  }

  AppLanguage get currentLanguage {
    return selectedLanguage.value;
  }

  Locale get currentLocale {
    return _localeFromLanguage(
      selectedLanguage.value,
    );
  }

  void _initializeLanguage() {
    Locale? locale =
        Get.locale ?? Get.deviceLocale;

    selectedLanguage.value =
        _languageFromLocale(locale);
  }

  AppLanguage _languageFromLocale(
      Locale? locale,
      ) {
    switch (locale?.languageCode) {
      case 'km':
        return AppLanguage.khmer;

      case 'zh':
        return AppLanguage.chinese;

      case 'en':
      default:
        return AppLanguage.english;
    }
  }

  Locale _localeFromLanguage(
      AppLanguage language,
      ) {
    switch (language) {
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

      case AppLanguage.chinese:
        return Locale(
          'zh',
          'CN',
        );
    }
  }

  Future<void> changeLanguage(
      AppLanguage language,
      ) async {
    if (_isChangingLanguage ||
        selectedLanguage.value == language) {
      return;
    }

    _isChangingLanguage = true;

    try {
      Locale locale =
      _localeFromLanguage(language);

      selectedLanguage.value = language;

      await Get.updateLocale(locale);
    } finally {
      _isChangingLanguage = false;
    }
  }

  void changeTheme(
      ThemeMode mode,
      ) {
    if (themeMode.value == mode) {
      return;
    }

    themeMode.value = mode;

    Get.changeThemeMode(mode);
  }

  Future<void> logout() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    await Get.offAllNamed(
      AppRoutes.login,
    );
  }
}