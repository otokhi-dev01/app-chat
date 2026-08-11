import 'package:appchat/screen/settings/section/settings_navigation_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/contact_controller.dart';
import '../../../route/app_route.dart';
import 'action_section_title.dart';
import 'settings_divider.dart';
import 'settings_section_title.dart';

class ContactSettingsSection extends StatelessWidget {
  final ContactController contactController;


  const ContactSettingsSection({
    super.key,
    required this.contactController,
  });

  void _openRoute(String route) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (Get.currentRoute == route) return;
    Get.toNamed(route, preventDuplicates: true);
  }

  Future<void> _confirmDeleteSyncedContacts(BuildContext context) async {
    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: Text('delete_synced_contacts'.tr),
          content: Text('delete_synced_contacts_confirmation'.tr),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text('cancel'.tr),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('delete'.tr),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await contactController.deleteSyncedContacts();
    }
  }

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
          title: 'contacts'.tr,
          icon: CupertinoIcons.person_2,
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
                return ActionSettingsTile(
                  icon: CupertinoIcons.person_crop_circle_badge_checkmark,
                  title: 'sync_contacts'.tr,
                  subtitle: 'sync_contacts_description'.tr,
                  buttonText: 'sync_now'.tr,
                  isLoading: contactController.isSyncingContacts.value,
                  onPressed: contactController.syncPhoneContacts,
                );
              }),
              SettingsDivider(color: dividerColor),
              SettingsNavigationTile(
                icon: CupertinoIcons.slash_circle,
                title: 'blocked_contacts'.tr,
                subtitle: 'manage_blocked'.tr,
                onTap: () {
                  _openRoute(AppRoutes.blockedContacts);
                },
              ),
              SettingsDivider(color: dividerColor),
              Obx(() {
                return ActionSettingsTile(
                  icon: CupertinoIcons.trash_fill,
                  title: 'delete_synced_contacts'.tr,
                  subtitle: 'delete_synced_contacts_desc'.tr,
                  buttonText: 'delete'.tr,
                  isLoading: contactController.isDeletingSyncedContacts.value,
                  onPressed: () => _confirmDeleteSyncedContacts(context),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}