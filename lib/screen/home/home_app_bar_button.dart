import 'dart:ui';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fallback glass colors based on current theme
    final glassColor = backgroundColor ??
        (isDark
            ? Colors.white.withOpacity(0.12)
            : Colors.white.withOpacity(0.45));

    final glassBorderColor = isDark
        ? Colors.white.withOpacity(0.18)
        : Colors.white.withOpacity(0.6);

    final iconClr = foregroundColor ??
        (isDark ? Colors.white : const Color(0xFF1C1C1E));

    return Tooltip(
      message: tooltip,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded iOS aesthetic
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0), // Frosted glass blur
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: glassBorderColor,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
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
                color: iconClr,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}