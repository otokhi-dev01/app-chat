import 'package:flutter/material.dart';

class SettingsIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const SettingsIcon({
    super.key,
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? colorScheme.primary.withValues(alpha: 0.16)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        size: 22,
        color: active ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
    );
  }
}