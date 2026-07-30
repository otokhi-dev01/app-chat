import 'package:appchat/screen/widgets/settings/settings_smooth_title.dart';
import 'package:appchat/screen/widgets/settings/settings_title_text.dart';
import 'package:flutter/material.dart';

import 'settings_icon.dart';

class SettingsNavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  const SettingsNavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return SettingsSmoothTile(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SettingsIcon(icon: icon),
            const SizedBox(width: 13),
            Expanded(
              child: SettingsTileText(title: title, subtitle: subtitle),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}