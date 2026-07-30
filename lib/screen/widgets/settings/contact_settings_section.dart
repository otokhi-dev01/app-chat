import 'package:appchat/screen/widgets/settings/settings_navigation_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/contact_controller.dart';
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
        SettingsSectionTitle(title: 'contacts'.tr),
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
                return ActionSettingsTile(
                  icon: Icons.contacts_outlined,
                  title: 'sync_contacts'.tr,
                  subtitle: 'sync_contacts_description'.tr,
                  buttonText: 'sync_now'.tr,
                  isLoading: contactController.isSyncingContacts.value,
                  onPressed: contactController.syncPhoneContacts,
                );
              }),

              // Placeholder rows for other contact-related settings —
              // wire real routes/controller values in, or remove if
              // you don't have these yet.
              SettingsDivider(color: dividerColor),

              SettingsNavigationTile(
                icon: Icons.block_outlined,
                title: 'blocked_contacts'.tr,
                subtitle: 'manage_blocked'.tr,
                onTap: () {
                  // _openRoute(AppRoutes.blockedContacts);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}