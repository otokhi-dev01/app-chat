import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screen/widgets/common/app_feedback.dart';
import '../../services/notification/notification_settings_service.dart';

class NotificationController
    extends GetxController {
  final NotificationSettingsService
  notificationSettingsService;

  NotificationController({
    NotificationSettingsService?
    notificationSettingsService,
  }) : notificationSettingsService =
      notificationSettingsService ??
          NotificationSettingsService();

  final RxBool notificationsEnabled =
      false.obs;

  final RxBool isUpdatingNotifications =
      false.obs;

  @override
  void onInit() {
    super.onInit();

    loadNotificationSetting();
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
}