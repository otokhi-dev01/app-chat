import 'package:flutter/material.dart';

/// UPDATED: Unit UI date separator pill displayed between chat message date groups
class ChatDateDivider extends StatelessWidget {
  final String label;

  const ChatDateDivider({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // UPDATED: Access current theme and colorScheme for dynamic light/dark mode adaptation
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    // UPDATED: Standardized unit UI colors for divider lines, capsule background, and borders
    Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color pillBackground = isDark
        ? const Color(0xFF1B1D22)
        : const Color(0xFFF2F4F7);

    Color pillBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          // UPDATED: Left indented divider line matching unit UI line thickness and color
          Expanded(
            child: Divider(
              indent: 32,
              endIndent: 12,
              thickness: 1,
              color: dividerColor,
            ),
          ),

          // UPDATED: Glass-style pill capsule container with theme border
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: pillBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: pillBorderColor,
                width: 1,
              ),
            ),
            // UPDATED: Uses theme.textTheme and onSurfaceVariant color for clean typography
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // UPDATED: Right indented divider line matching unit UI line thickness and color
          Expanded(
            child: Divider(
              indent: 12,
              endIndent: 32,
              thickness: 1,
              color: dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}