import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profile/profile_controller.dart';
import '../../../route/app_route.dart';
import 'settings_drawer_menu_list.dart'; // adjust path to match where you saved it

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
        bottom: false,
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
            const SettingsDrawerMenuList(),
          ],
        ),
      ),
    );
  }
}