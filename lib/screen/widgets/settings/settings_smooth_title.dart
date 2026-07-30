import 'package:flutter/material.dart';

class SettingsSmoothTile extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const SettingsSmoothTile({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color pressedColor = isDark
        ? Colors.white.withValues(alpha: 0.055)
        : Colors.black.withValues(alpha: 0.035);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.focused)) {
              return pressedColor;
            }
            return Colors.transparent;
          },
        ),
        child: child,
      ),
    );
  }
}