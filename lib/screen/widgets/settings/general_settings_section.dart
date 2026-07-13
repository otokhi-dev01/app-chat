import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings_controller.dart';

class GeneralSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const GeneralSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme
            .of(context)
            .brightness == Brightness.dark;

    final Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'general'.tr),

        const SizedBox(height: 8),

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
          child: Column(
            children: [
              Obx(
                    () =>
                    _SwitchSettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'notifications'.tr,
                      subtitle: 'enable_notifications'.tr,
                      value: controller.notificationsEnabled.value,
                      onChanged: controller.toggleNotifications,
                    ),
              ),

              Divider(
                height: 1,
                indent: 69,
                color: dividerColor,
              ),

              _NavigationSettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'privacy_security'.tr,
                subtitle: 'manage_privacy'.tr,
                onTap: () {},
              ),

              Divider(
                height: 1,
                indent: 69,
                color: dividerColor,
              ),

              _NavigationSettingsTile(
                icon: Icons.storage_outlined,
                title: 'data_storage'.tr,
                subtitle: 'manage_storage'.tr,
                onTap: () {},
              ),

              Divider(
                height: 1,
                indent: 69,
                color: dividerColor,
              ),

              _NavigationSettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'about_app'.tr,
                subtitle: 'version_information'.tr,
                trailingText: '1.0.0',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          color: value
              ? primary.withValues(alpha: 0.06)
              : Colors.transparent,
          child: Row(
            children: [
              _SettingsIcon(
                icon: icon,
                active: value,
              ),

              const SizedBox(width: 13),

              Expanded(
                child: _SettingsTileText(
                  title: title,
                  subtitle: subtitle,
                  active: value,
                ),
              ),

              const SizedBox(width: 10),

              Switch.adaptive(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  const _NavigationSettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              _SettingsIcon(icon: icon),

              const SizedBox(width: 13),

              Expanded(
                child: _SettingsTileText(
                  title: title,
                  subtitle: subtitle,
                ),
              ),

              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
              ],

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const _SettingsIcon({
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: active
            ? primary.withValues(alpha: 0.16)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        size: 22,
        color: active
            ? primary
            : colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _SettingsTileText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;

  const _SettingsTileText({
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: active
                ? colorScheme.primary
                : colorScheme.onSurface,
            fontWeight: active
                ? FontWeight.w700
                : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 69),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Theme.of(context)
            .colorScheme
            .outlineVariant
            .withValues(alpha: 0.45),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}