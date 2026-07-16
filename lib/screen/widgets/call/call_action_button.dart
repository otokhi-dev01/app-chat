import 'package:flutter/material.dart';

class CallActionButton extends StatelessWidget {
  final String label;
  final String tooltip;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  CallActionButton({
    super.key,
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color inactiveColor = isDark
        ? Colors.white.withValues(
      alpha: 0.09,
    )
        : Color(0xFFF2F4F7);

    Color backgroundColor = isActive
        ? colorScheme.primary
        : inactiveColor;

    Color foregroundColor = isActive
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return SizedBox(
      width: 74,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: tooltip,
            child: Material(
              color: backgroundColor,
              shape: CircleBorder(),
              child: InkWell(
                onTap: onTap,
                customBorder: CircleBorder(),
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: Icon(
                    icon,
                    color: foregroundColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}