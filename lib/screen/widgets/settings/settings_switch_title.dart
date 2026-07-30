import 'package:appchat/screen/widgets/settings/settings_smooth_title.dart';
import 'package:appchat/screen/widgets/settings/settings_title_text.dart';
import 'package:flutter/material.dart';

import 'settings_icon.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SettingsSmoothTile(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        color: value
            ? colorScheme.primary.withValues(alpha: 0.06)
            : Colors.transparent,
        child: Row(
          children: [
            SettingsIcon(icon: icon, active: value),
            const SizedBox(width: 13),
            Expanded(
              child: SettingsTileText(
                title: title,
                subtitle: subtitle,
                active: value,
              ),
            ),
            const SizedBox(width: 10),
            IgnorePointer(
              child: Switch.adaptive(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}