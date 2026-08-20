import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../route/app_route.dart';
import '../../services/contact_service/contact_api_service.dart';
import '../../services/contact_service/phone_contact_api_service.dart';
import 'section/about_settings_section.dart';
import 'section/contact_settings_section.dart';
import 'section/display_langauge_settings_section.dart';
import 'section/general_settings_section.dart';
import '../widgets/logout_button.dart';

class SettingsSideDrawer extends StatelessWidget {
  const SettingsSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final SettingsController settingsController =
        Get.isRegistered<SettingsController>()
            ? Get.find<SettingsController>()
            : Get.put(SettingsController(), permanent: true);

    final NotificationController notificationController =
        Get.isRegistered<NotificationController>()
            ? Get.find<NotificationController>()
            : Get.put(NotificationController(), permanent: true);

    final ContactController contactController =
        Get.isRegistered<ContactController>()
            ? Get.find<ContactController>()
            : Get.put(
                ContactController(
                  contactApiService: Get.find<ContactApiService>(),
                  phoneContactApiService: Get.find<PhoneContactApiService>(),
                ),
                permanent: true,
              );

    final ProfileController? profileController =
        Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : null;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1B1D22) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            final String appVersion = snapshot.data?.version ?? '';
            final String buildNumber = snapshot.data?.buildNumber ?? '';

            return ListView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                // Header with search & close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'settings'.tr,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.search, size: 20),
                          tooltip: 'search_settings'.tr,
                          onPressed: () {
                            Navigator.pop(context);
                            Get.toNamed(AppRoutes.settingsSearch);
                          },
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.xmark, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // User Profile Header Card
                if (profileController != null) ...[
                  _UserProfileHeaderCard(controller: profileController),
                  const SizedBox(height: 20),
                ],

                GeneralSettingsSection(
                  settingsController: settingsController,
                  notificationController: notificationController,
                ),

                const SizedBox(height: 24),

                ContactSettingsSection(
                  contactController: contactController,
                ),

                const SizedBox(height: 24),

                DisplayLanguageSettingsSection(
                  controller: settingsController,
                ),

                const SizedBox(height: 24),

                AboutSettingsSection(
                  appVersion: appVersion,
                  buildNumber: buildNumber,
                ),

                const SizedBox(height: 24),

                LogoutButton(
                  controller: settingsController,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserProfileHeaderCard extends StatelessWidget {
  final ProfileController controller;

  const _UserProfileHeaderCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Obx(() {
      final name =
          controller.name.value.isEmpty ? 'profile'.tr : controller.name.value;
      final phoneOrEmail = controller.userPhone.value.isNotEmpty
          ? controller.userPhone.value
          : (controller.userEmail.value.isNotEmpty
              ? controller.userEmail.value
              : controller.userUsername.value);

      return Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.editProfile);
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        colorScheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (phoneOrEmail.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            phoneOrEmail,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}