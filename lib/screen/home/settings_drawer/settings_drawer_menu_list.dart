import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../controllers/contact/contact_controller.dart';
import '../../../controllers/notification/notification_controller.dart';
import '../../../controllers/settings/settings_controller.dart';
import '../../../route/app_route.dart';
import '../../../services/contact_service/contact_api_service.dart';
import '../../../services/contact_service/phone_contact_api_service.dart';
import '../../../services/user_service/user_service.dart';
import '../../settings/display/display_settings_screen.dart';
import '../../settings/language/language_settings_screen.dart';


class SettingsDrawerMenuList extends StatelessWidget {
  const SettingsDrawerMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.qrcode_viewfinder),
            title: Text('scan_qr_code'.tr),
            onTap: () async {
              Navigator.pop(context);

              final PermissionStatus cameraStatus = await Permission.camera.status;

              if (cameraStatus.isDenied) {
                final PermissionStatus result = await Permission.camera.request();
                if (!result.isGranted) {
                  Get.snackbar(
                    'permission_required'.tr,
                    'camera_permission_required_message'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
              } else if (cameraStatus.isPermanentlyDenied || cameraStatus.isRestricted) {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text('permission_required'.tr),
                    content: Text('enable_camera_in_settings'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('cancel'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          openAppSettings();
                        },
                        child: Text('open_settings'.tr),
                      ),
                    ],
                  ),
                );
                return;
              }

              Get.toNamed(AppRoutes.qrScanner);
            },
          ),
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
          Obx(() {
            final NotificationController notificationController =
            Get.isRegistered<NotificationController>()
                ? Get.find<NotificationController>()
                : Get.put(NotificationController(), permanent: true);

            return ListTile(
              leading: const Icon(CupertinoIcons.bell),
              title: Text('notifications'.tr),
              trailing: notificationController.isUpdatingNotifications.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: notificationController.notificationsEnabled.value,
                  onChanged: (bool value) {
                    notificationController.toggleNotifications(value);
                  },
                ),
              ),
            );
          }),
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
          Obx(() {
            final ContactController contactController = Get.isRegistered<ContactController>()
                ? Get.find<ContactController>()
                : Get.put(
              ContactController(
                contactApiService: Get.find<ContactApiService>(),
                phoneContactApiService: Get.find<PhoneContactApiService>(),
              ),
              permanent: true,
            );

            return ListTile(
              leading: const Icon(CupertinoIcons.person_crop_circle_badge_checkmark),
              title: Text('sync_contacts'.tr),
              trailing: contactController.isSyncingContacts.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(CupertinoIcons.chevron_right, size: 18, color: Colors.grey),
              onTap: contactController.isSyncingContacts.value
                  ? null
                  : () async {
                await contactController.syncPhoneContacts();
                if (context.mounted) Navigator.pop(context);
              },
            );
          }),
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
    );
  }
}