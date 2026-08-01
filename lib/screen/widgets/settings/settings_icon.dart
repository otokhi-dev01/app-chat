import 'package:flutter/material.dart';

class SettingsIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const SettingsIcon({
    super.key,
    required this.icon,
    this.active = true, // Defaults to true so all icons match Account section
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color primary = colorScheme.primary;

    Color bgColor = active
        ? primary.withValues(alpha: 0.11)
        : colorScheme.surfaceContainerHighest;

    Color iconColor = active ? primary : colorScheme.onSurfaceVariant;

    return AnimatedContainer(
      duration: Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        size: 20,
        color: iconColor,
      ),
    );
  }
}