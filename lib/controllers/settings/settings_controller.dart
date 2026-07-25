import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route/app_route.dart';
import '../../screen/widgets/common/app_feedback.dart';
import '../../services/notification/notification_settings_service.dart';

enum AppLanguage {
  english,
  khmer,
}

class SettingsController extends GetxController {
  final NotificationSettingsService
  notificationSettingsService;

  SettingsController({
    NotificationSettingsService?
    notificationSettingsService,
  }) : notificationSettingsService =
      notificationSettingsService ??
          NotificationSettingsService();

  final RxBool notificationsEnabled =
      false.obs;

  final RxBool isUpdatingNotifications =
      false.obs;

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

  @override
  void onInit() {
    super.onInit();

    loadNotificationSetting();
  }

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

  Future<void> loadNotificationSetting() async {
    try {
      bool enabled =
      await notificationSettingsService
          .loadEnabledState();

      notificationsEnabled.value = enabled;
    } catch (error) {
      notificationsEnabled.value = false;

      debugPrint(
        'Failed to load notification setting: $error',
      );
    }
  }

  Future<void> toggleNotifications(
      bool value,
      ) async {
    if (isUpdatingNotifications.value) {
      return;
    }

    if (notificationsEnabled.value == value) {
      return;
    }

    try {
      isUpdatingNotifications.value = true;

      NotificationUpdateResult result =
      await notificationSettingsService
          .updateEnabledState(value);

      switch (result) {
        case NotificationUpdateResult.enabled:
          notificationsEnabled.value = true;

          AppFeedback.showMessage(
            title: 'notifications_enabled'.tr,
            message:
            'notifications_enabled_message'.tr,
            icon:
            Icons.notifications_active_outlined,
          );

          break;

        case NotificationUpdateResult.disabled:
          notificationsEnabled.value = false;

          AppFeedback.showMessage(
            title: 'notifications_disabled'.tr,
            message:
            'notifications_disabled_message'.tr,
            icon:
            Icons.notifications_off_outlined,
          );

          break;

        case NotificationUpdateResult.denied:
          notificationsEnabled.value = false;

          AppFeedback.showMessage(
            title: 'permission_denied'.tr,
            message:
            'notification_permission_denied'.tr,
            icon: Icons.info_outline_rounded,
          );

          break;

        case NotificationUpdateResult
            .permanentlyDenied:
          notificationsEnabled.value = false;

          AppFeedback.showMessage(
            title: 'permission_required'.tr,
            message:
            'enable_notifications_in_settings'.tr,
            icon: Icons.settings_outlined,
          );

          break;
      }
    } catch (error) {
      notificationsEnabled.value = false;

      AppFeedback.showMessage(
        title: 'unable_to_update'.tr,
        message:
        'notification_update_failed'.tr,
        icon: Icons.error_outline_rounded,
      );

      debugPrint(
        'Notification update failed: $error',
      );
    } finally {
      isUpdatingNotifications.value = false;
    }
  }

  Future<void> openNotificationSettings() async {
    await notificationSettingsService
        .openSettings();
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

    if (newValue == userBio.value) {
      return;
    }

    userBio.value = newValue;
  }

  Future<void> logout() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    await Get.offAllNamed(
      AppRoutes.login,
    );
  }
}