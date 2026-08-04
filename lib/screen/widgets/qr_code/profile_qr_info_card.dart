import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileQrInfoCard extends StatelessWidget {
  const ProfileQrInfoCard({
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
        color: colorScheme.primary.withValues(
          alpha: isDark ? 0.12 : 0.08,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.primary.withValues(
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
              color: colorScheme.primary.withValues(
                alpha: 0.14,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              CupertinoIcons.info_circle,
              color: colorScheme.primary,
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'share_qr_trusted_contacts'.tr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}