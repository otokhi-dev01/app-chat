import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileInformationTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  const ProfileInformationTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color primary = colorScheme.primary;

    final bool isEmpty = value.trim().isEmpty;

    final String displayValue = isEmpty
        ? 'not_set'.tr
        : value.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              size: 22,
              color: primary,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                  theme.textTheme.bodySmall?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  displayValue,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style:
                  theme.textTheme.bodyLarge?.copyWith(
                    color: isEmpty
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
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