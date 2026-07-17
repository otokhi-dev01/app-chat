import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';

class GeneralSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const GeneralSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
            color: isDark ? const Color(0xFF1B1D22) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: Column(
            children: [
              Obx(
                    () => _SwitchSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'notifications'.tr,
                  subtitle: 'enable_notifications'.tr,
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                ),
              ),
              _SettingsDivider(color: dividerColor),
              _NavigationSettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'privacy_security'.tr,
                subtitle: 'manage_privacy'.tr,
                onTap: () {},
              ),
              _SettingsDivider(color: dividerColor),
              // 1. Added Chat Folders Button (Localized)
              _NavigationSettingsTile(
                icon: Icons.folder_open_outlined,
                title: 'chat_folders'.tr,
                subtitle: 'manage_folders'.tr,
                onTap: () {},
              ),
              _SettingsDivider(color: dividerColor),
              // 2. Added Devices Button (Localized)
              _NavigationSettingsTile(
                icon: Icons.devices_outlined,
                title: 'devices'.tr,
                subtitle: 'manage_devices'.tr,
                onTap: () {},
              ),
              _SettingsDivider(color: dividerColor),
              _NavigationSettingsTile(
                icon: Icons.storage_outlined,
                title: 'data_storage'.tr,
                subtitle: 'manage_storage'.tr,
                onTap: () {},
              ),
              _SettingsDivider(color: dividerColor),
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

    return _BouncySettingsTile(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        color: value ? primary.withValues(alpha: 0.06) : Colors.transparent,
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

    return _BouncySettingsTile(
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

    final Widget iconContainer = AnimatedContainer(
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
        color: active ? primary : colorScheme.onSurfaceVariant,
      ),
    );

    return AnimatedScale(
      scale: active ? 1.06 : 1.0,
      duration: const Duration(milliseconds: 240),
      curve: const Cubic(0.2, 1.4, 0.3, 1.0),
      child: iconContainer,
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
            color: active ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
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
  final Color color;

  const _SettingsDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 69),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
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

class _BouncySettingsTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncySettingsTile({
    required this.child,
    required this.onTap,
  });

  @override
  State<_BouncySettingsTile> createState() => _BouncySettingsTileState();
}

class _BouncySettingsTileState extends State<_BouncySettingsTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}