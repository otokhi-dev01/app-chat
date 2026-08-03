import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacySecurityCard extends StatelessWidget {
  final List<Widget> children;

  const PrivacySecurityCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class PrivacySecurityDivider extends StatelessWidget {
  const PrivacySecurityDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color dividerColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 69,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: dividerColor,
      ),
    );
  }
}

class PrivacySecuritySectionTitle extends StatelessWidget {
  final String title;

  const PrivacySecuritySectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class PrivacySecurityHeader extends StatelessWidget {
  const PrivacySecurityHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              CupertinoIcons.shield_fill,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'protect_your_account'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'privacy_header_description'.tr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacySecurityWarning extends StatelessWidget {
  const PrivacySecurityWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(
          alpha: isDark ? 0.12 : 0.08,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.error.withValues(
            alpha: isDark ? 0.22 : 0.15,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(
                alpha: 0.14,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              CupertinoIcons.info_circle,
              color: colorScheme.error,
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'privacy_warning_description'.tr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}