import 'package:appchat/screen/settings/section/settings_navigation_title.dart';
import 'package:appchat/screen/settings/section/settings_switch_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../controllers/notification/notification_controller.dart';
import '../../../controllers/settings/settings_controller.dart';
import '../../../route/app_route.dart';
import 'settings_divider.dart';
import 'settings_section_title.dart';

class GeneralSettingsSection extends StatelessWidget {
  final SettingsController settingsController;
  final NotificationController notificationController;

  const GeneralSettingsSection({
    super.key,
    required this.settingsController,
    required this.notificationController,
  });

  void _openRoute(String route) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (Get.currentRoute == route) return;
    Get.toNamed(route, preventDuplicates: true);
  }

  List<_NavRowData> get _navRows => [
    _NavRowData(
      icon: CupertinoIcons.lock,
      title: 'privacy_security'.tr,
      subtitle: 'manage_privacy'.tr,
      route: AppRoutes.privacySecurity,
    ),
    _NavRowData(
      icon: CupertinoIcons.folder,
      title: 'chat_folders'.tr,
      subtitle: 'manage_folders'.tr,
      route: AppRoutes.chatFolders,
    ),
    _NavRowData(
      icon: CupertinoIcons.device_phone_portrait,
      title: 'devices'.tr,
      subtitle: 'manage_devices'.tr,
      route: AppRoutes.devices,
    ),
    _NavRowData(
      icon: CupertinoIcons.tray_arrow_up,
      title: 'data_storage'.tr,
      subtitle: 'manage_storage'.tr,
      route: AppRoutes.dataStorage,
    ),
    _NavRowData(
      icon: CupertinoIcons.info,
      title: 'about_app'.tr,
      subtitle: 'version_information'.tr,
      route: AppRoutes.about,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;
    Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(
          title: 'general'.tr,
          icon: CupertinoIcons.gear_alt,
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.15 : 0.04,
                ),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Obx(() {
                String subtitleText = 'enable_notifications'.tr;
                if (notificationController.isUpdatingNotifications.value) {
                  subtitleText = 'updating'.tr;
                } else if (notificationController
                        .permissionStatus.value.isPermanentlyDenied ||
                    notificationController
                        .permissionStatus.value.isRestricted) {
                  subtitleText = 'enable_notifications_in_settings'.tr;
                }

                return SettingsSwitchTile(
                  icon: CupertinoIcons.bell,
                  title: 'notifications'.tr,
                  subtitle: subtitleText,
                  value: notificationController.notificationsEnabled.value,
                  onChanged: notificationController.toggleNotifications,
                );
              }),
              for (final row in _navRows) ...[
                SettingsDivider(color: dividerColor),
                SettingsNavigationTile(
                  icon: row.icon,
                  title: row.title,
                  subtitle: row.subtitle,
                  onTap: () => _openRoute(row.route),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NavRowData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  _NavRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}