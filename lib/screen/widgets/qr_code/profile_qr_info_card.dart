import 'package:flutter/material.dart';

class ProfileQrInfoCard
    extends StatelessWidget {
  ProfileQrInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary
            .withValues(
          alpha: isDark ? 0.10 : 0.07,
        ),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.primary
              .withValues(
            alpha: 0.13,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.primary,
            size: 21,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Only share this QR code with people you trust.',
              style: theme
                  .textTheme.bodyMedium
                  ?.copyWith(
                color:
                colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}