import 'package:appchat/screen/widgets/settings/settings_navigation_title.dart';
import 'package:appchat/screen/widgets/settings/settings_switch_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      icon: Icons.lock_outline_rounded,
      title: 'privacy_security'.tr,
      subtitle: 'manage_privacy'.tr,
      route: AppRoutes.privacySecurity,
    ),
    _NavRowData(
      icon: Icons.folder_open_outlined,
      title: 'chat_folders'.tr,
      subtitle: 'manage_folders'.tr,
      route: AppRoutes.chatFolders,
    ),
    _NavRowData(
      icon: Icons.devices_outlined,
      title: 'devices'.tr,
      subtitle: 'manage_devices'.tr,
      route: AppRoutes.devices,
    ),
    _NavRowData(
      icon: Icons.storage_outlined,
      title: 'data_storage'.tr,
      subtitle: 'manage_storage'.tr,
      route: AppRoutes.dataStorage,
    ),
    _NavRowData(
      icon: Icons.info_outline_rounded,
      title: 'about_app'.tr,
      subtitle: 'version_information'.tr,
      route: AppRoutes.about,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: 'general'.tr),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: dividerColor),
          ),
          child: Column(
            children: [
              Obx(() {
                return SettingsSwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'notifications'.tr,
                  subtitle: notificationController.isUpdatingNotifications.value
                      ? 'updating'.tr
                      : 'enable_notifications'.tr,
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

  const _NavRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}