import 'package:flutter/material.dart';

class ContactSectionHeader
    extends StatelessWidget {
  final String letter;

  ContactSectionHeader({
    super.key,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        14,
        8,
        14,
        5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary
            .withValues(alpha: 0.08),
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Text(
        letter,
        style: theme.textTheme.labelLarge
            ?.copyWith(
          color: colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}