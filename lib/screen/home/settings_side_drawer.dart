import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../route/app_route.dart';
import '../../services/contact_service/contact_api_service.dart';
import '../../services/contact_service/phone_contact_api_service.dart';
import '../../services/user_service/user_service.dart';
import '../settings/display/display_settings_screen.dart';
import '../settings/language/language_settings_screen.dart';

class SettingsSideDrawer extends StatelessWidget {
  const SettingsSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1B1D22) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header / Account Preview
            Obx(() {
              final ProfileController? profileController =
                  Get.isRegistered<ProfileController>()
                      ? Get.find<ProfileController>()
                      : null;

              final String name = profileController?.name.value.isNotEmpty == true
                  ? profileController!.name.value
                  : 'settings'.tr;

              final String subtitle = profileController?.userPhone.value.isNotEmpty == true
                  ? profileController!.userPhone.value
                  : (profileController?.userEmail.value.isNotEmpty == true
                      ? profileController!.userEmail.value
                      : 'quick_actions'.tr);

              return InkWell(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Get.toNamed(AppRoutes.editProfile);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        child: Text(
                          name != 'settings'.tr && name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: Colors.grey.withValues(alpha: 0.8),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Divider(height: 1),

            // Side Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(CupertinoIcons.qrcode),
                    title: Text('my_qr_code'.tr),
                    onTap: () async {
                      Get.back();

                      try {
                        final userApiService = Get.find<UserApiService>();

                        final user = userApiService.currentUserValue ??
                            await userApiService.getProfile();

                        Get.toNamed(
                          AppRoutes.profileQrCode,
                          arguments: {
                            'userId': user.id,
                            'name': user.name ?? '',
                            'username': user.username ?? '',
                          },
                        );
                      } catch (error) {
                        Get.snackbar(
                          'Error',
                          'Unable to load your profile.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.bell),
                    title: Text('notifications'.tr),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.lock_shield),
                    title: Text('privacy_security'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(AppRoutes.privacySecurity);
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.paintbrush),
                    title: Text('appearance'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      final SettingsController settingsController = Get.isRegistered<SettingsController>()
                          ? Get.find<SettingsController>()
                          : Get.put(SettingsController(), permanent: true);
                      Get.to(
                            () => DisplaySettingsScreen(
                          controller: settingsController,
                        ),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 280),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.folder),
                    title: Text('chat_folders'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(AppRoutes.chatFolders);
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.person_crop_circle_badge_checkmark),
                    title: Text('sync_contacts'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      final ContactController contactController = Get.isRegistered<ContactController>()
                          ? Get.find<ContactController>()
                          : Get.put(ContactController(contactApiService: Get.find<ContactApiService>(), phoneContactApiService: Get.find<PhoneContactApiService>()), permanent: true);
                      contactController.syncPhoneContacts();
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.globe),
                    title: Text('language'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      final SettingsController settingsController = Get.isRegistered<SettingsController>()
                          ? Get.find<SettingsController>()
                          : Get.put(SettingsController(), permanent: true);
                      Get.to(
                            () => LanguageSettingsScreen(
                          controller: settingsController,
                        ),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 280),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.device_phone_portrait),
                    title: Text('devices'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(AppRoutes.devices);
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.chart_pie),
                    title: Text('data_storage'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(AppRoutes.dataStorage);
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.question_circle),
                    title: Text('help'.tr),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(AppRoutes.about);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(CupertinoIcons.square_arrow_right, color: Colors.red),
                    title: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      showCupertinoDialog<void>(
                        context: context,
                        builder: (dialogContext) {
                          return CupertinoAlertDialog(
                            title: Text('logout'.tr),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('logout_confirmation'.tr),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text('cancel'.tr),
                              ),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  final SettingsController settingsController = Get.isRegistered<SettingsController>()
                                      ? Get.find<SettingsController>()
                                      : Get.put(SettingsController(), permanent: true);
                                  settingsController.logout();
                                },
                                child: Text('logout'.tr),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
