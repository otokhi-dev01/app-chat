import 'package:flutter/material.dart';

class SettingsTileText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;

  const SettingsTileText({
    super.key,
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    TextStyle fallbackStyle = TextStyle(
      color: active ? colorScheme.primary : colorScheme.onSurface,
      fontWeight: active ? FontWeight.w700 : FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: active ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
          ) ??
              fallbackStyle,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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