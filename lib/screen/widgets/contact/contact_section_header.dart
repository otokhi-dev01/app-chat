import 'package:flutter/material.dart';

class ContactSectionHeader extends StatelessWidget {
  final String letter;

  ContactSectionHeader({
    super.key,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color backgroundColor =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.16 : 0.10,
    );

    Color borderColor =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.22 : 0.16,
    );

    String title = letter.trim().isEmpty
        ? '#'
        : letter.trim();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        14,
        10,
        14,
        6,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 30,
            maxWidth:
            MediaQuery.sizeOf(context).width *
                0.65,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              20,
            ),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium
                ?.copyWith(
              color: colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}