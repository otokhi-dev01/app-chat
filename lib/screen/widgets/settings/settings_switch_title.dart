import 'package:appchat/screen/widgets/settings/settings_title_text.dart';
import 'package:flutter/cupertino.dart';
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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          SettingsIcon(
            icon: icon,
            active: value, // Highlights icon badge when switch is ON
          ),
          SizedBox(width: 13),
          Expanded(
            child: SettingsTileText(
              title: title,
              subtitle: subtitle,
              active: value, // Highlights title text when switch is ON
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: colorScheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}