import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../screen/widgets/app_feedback.dart';
import '../../services/notification/notification_settings_service.dart';

class NotificationController extends GetxController
    with WidgetsBindingObserver {
  final NotificationSettingsService notificationSettingsService;

  NotificationController({
    NotificationSettingsService? notificationSettingsService,
  }) : notificationSettingsService =
            notificationSettingsService ?? NotificationSettingsService();

  final RxBool notificationsEnabled = false.obs;
  final RxBool isUpdatingNotifications = false.obs;
  final Rx<PermissionStatus> permissionStatus =
      PermissionStatus.denied.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadNotificationSetting();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadNotificationSetting();
    }
  }

  Future<void> loadNotificationSetting() async {
    try {
      PermissionStatus status =
          await notificationSettingsService.checkPermissionStatus();
      permissionStatus.value = status;

      bool enabled =
          await notificationSettingsService.loadEnabledState();

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

    if (notificationsEnabled.value == value && value == true) {
      return;
    }

    try {
      isUpdatingNotifications.value = true;

      PermissionStatus currentStatus =
          await notificationSettingsService.checkPermissionStatus();
      permissionStatus.value = currentStatus;

      if (value &&
          (currentStatus.isPermanentlyDenied ||
              currentStatus.isRestricted)) {
        notificationsEnabled.value = false;
        _showPermissionSettingsDialog();
        return;
      }

      NotificationUpdateResult result =
          await notificationSettingsService.updateEnabledState(value);

      permissionStatus.value =
          await notificationSettingsService.checkPermissionStatus();

      switch (result) {
        case NotificationUpdateResult.enabled:
          notificationsEnabled.value = true;

          AppFeedback.showMessage(
            title: 'notifications_enabled'.tr,
            message: 'notifications_enabled_message'.tr,
            icon: Icons.notifications_active_outlined,
          );

          break;

        case NotificationUpdateResult.disabled:
          notificationsEnabled.value = false;

          AppFeedback.showMessage(
            title: 'notifications_disabled'.tr,
            message: 'notifications_disabled_message'.tr,
            icon: Icons.notifications_off_outlined,
          );

          break;

        case NotificationUpdateResult.denied:
          notificationsEnabled.value = false;

          AppFeedback.showMessage(
            title: 'permission_denied'.tr,
            message: 'notification_permission_denied'.tr,
            icon: Icons.info_outline_rounded,
          );

          break;

        case NotificationUpdateResult.permanentlyDenied:
          notificationsEnabled.value = false;
          _showPermissionSettingsDialog();

          break;
      }
    } catch (error) {
      notificationsEnabled.value = false;

      AppFeedback.showMessage(
        title: 'unable_to_update'.tr,
        message: 'notification_update_failed'.tr,
        icon: Icons.error_outline_rounded,
      );

      debugPrint(
        'Notification update failed: $error',
      );
    } finally {
      isUpdatingNotifications.value = false;
    }
  }

  void _showPermissionSettingsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('permission_required'.tr),
        content: Text('enable_notifications_in_settings'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openNotificationSettings();
            },
            child: Text('open_settings'.tr),
          ),
        ],
      ),
    );
  }

  Future<void> openNotificationSettings() async {
    await notificationSettingsService.openSettings();
  }
}