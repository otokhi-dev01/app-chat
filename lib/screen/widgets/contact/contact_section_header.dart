import 'package:flutter/material.dart';

class ContactSectionHeader extends StatelessWidget {
  final String letter;

  const ContactSectionHeader({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF1B1D22) : const Color(0xFFF7F7F8),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Text(
        letter,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}