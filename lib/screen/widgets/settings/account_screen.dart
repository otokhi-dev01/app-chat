import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings_controller.dart';

class AccountSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const AccountSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            right: 6,
            bottom: 8,
          ),
          child: Text(
            'account'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1B1D22)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: Obx(
                () => Column(
              children: [
                _AccountTile(
                  icon: Icons.person_outline_rounded,
                  label: 'name'.tr,
                  value: controller.userName.value,
                ),
                _AccountDivider(color: dividerColor),
                _AccountTile(
                  icon: Icons.phone_outlined,
                  label: 'phone'.tr,
                  value: controller.userPhone.value,
                ),
                _AccountDivider(color: dividerColor),
                _AccountTile(
                  icon: Icons.email_outlined,
                  label: 'email'.tr,
                  value: controller.userEmail.value,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AccountTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    final String displayValue = value.trim().isEmpty
        ? 'not_set'.tr
        : value;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              size: 22,
              color: primary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: value.trim().isEmpty
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  final Color color;

  const _AccountDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 69,
      color: color,
    );
  }
}