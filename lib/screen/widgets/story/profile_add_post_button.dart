import 'package:flutter/material.dart';

class ProfileAddPostButton extends StatelessWidget {
  final VoidCallback onTap;

  ProfileAddPostButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.10,
    )
        : Colors.black.withValues(
      alpha: 0.07,
    );

    Color iconBackground =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.18 : 0.11,
    );

    Color shadowColor =
    Colors.black.withValues(
      alpha: isDark ? 0.25 : 0.10,
    );

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(
        16,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          16,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          height: 43,
          padding: EdgeInsets.fromLTRB(
            7,
            0,
            13,
            0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              16,
            ),
            border: Border.all(
              color: borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 14,
                offset: Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 31,
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius:
                  BorderRadius.circular(
                    11,
                  ),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Add Post',
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}