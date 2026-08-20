import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigation/main_navigation_controller.dart';
import '../../route/app_route.dart';
import '../contact/add_contact/add_contact_sheet.dart';

/// ADDED: Unit UI quick action card for Telegram-style New Message options
class NewMessageActionCard extends StatelessWidget {
  final VoidCallback onNewGroup;
  final VoidCallback onNewChannel;
  final Future<void> Function(
      String firstName,
      String lastName,
      String phone,
      String countryCode,
      ) onAddContactSave;

  const NewMessageActionCard({
    super.key,
    required this.onNewGroup,
    required this.onNewChannel,
    required this.onAddContactSave,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. New Group Action Button
          _ActionTile(
            icon: CupertinoIcons.person_3_fill,
            title: 'new_group'.tr,
            subtitle: 'create_group_chat'.tr,
            iconColor: colorScheme.primary,
            onTap: onNewGroup,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 68),
            child: Divider(height: 1, color: borderColor),
          ),

          // 2. New Channel Action Button
          _ActionTile(
            icon: CupertinoIcons.speaker_2_fill,
            title: 'new_channel'.tr,
            subtitle: 'broadcast_messages'.tr,
            iconColor: colorScheme.primary,
            onTap: onNewChannel,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 68),
            child: Divider(height: 1, color: borderColor),
          ),

          // 3. New Contact Action Button (Opens AddContactSheet)
          _ActionTile(
            icon: CupertinoIcons.person_badge_plus,
            title: 'new_contact'.tr,
            subtitle: 'add_to_contacts'.tr,
            iconColor: colorScheme.primary,
            onTap: () {
              Navigator.of(context).pop();

              if (Get.isRegistered<MainNavigationController>()) {
                Get.find<MainNavigationController>().goToContacts();
              } else {
                Get.toNamed(AppRoutes.contacts);
              }

              Future.delayed(const Duration(milliseconds: 300), () {
                if (Get.context != null) {
                  showAddContactSheet(
                    context: Get.context!,
                    onAdd: (data) {
                      onAddContactSave(
                        data.firstName,
                        data.lastName,
                        data.phoneNumber,
                        '',
                      );
                    },
                    onAddViaQrCode: () {},
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // 42x42 Primary Icon Box Container
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                CupertinoIcons.chevron_right,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}