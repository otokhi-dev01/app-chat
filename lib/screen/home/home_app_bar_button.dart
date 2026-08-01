import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBarActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;

  const HomeAppBarActionButton({
    super.key,
    required this.tooltip,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Follows the active code surface colors: Color(0xFF1B1D22) for Dark, Colors.white for Light
    final Color buttonBgColor = backgroundColor ??
        (isDark ? const Color(0xFF1B1D22) : Colors.white);

    // Follows the active code border colors
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    // Follows the active code icon/text color defaults
    final Color iconColor = foregroundColor ??
        (isDark ? Colors.white : const Color(0xFF1C1C1E));

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: buttonBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.15 : 0.04,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}