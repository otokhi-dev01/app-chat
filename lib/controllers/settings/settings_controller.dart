import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../services/auth_service /auth_api_service.dart';
import '../../services/chat_service/chat_list_api_service.dart';
import '../../services/folder_service/chat_folder_api_service.dart';
import '../../services/user_service/user_service.dart';

enum AppLanguage {
  english,
  khmer,
  chinese,
}

class SettingsController extends GetxController {
  final AuthApiService authApiService = Get.find<AuthApiService>();

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
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await authApiService.logout();
    } catch (e) {
      // Ignore API errors on logout to ensure local session clears
    }

    // Clear all cached per-user state from permanent services
    _clearAllCachedState();

    await Get.offAllNamed(
      AppRoutes.login,
    );
  }

  void _clearAllCachedState() {
    try {
      Get.find<UserApiService>().clearCurrentUser();
    } catch (_) {}

    try {
      Get.find<ChatFolderApiService>().folders.clear();
    } catch (_) {}

    try {
      // ChatListApiService does not cache in a field; API fetches fresh.
      Get.find<ChatListApiService>();
    } catch (_) {}
  }
}