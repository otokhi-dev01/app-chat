import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaQualitySheet extends StatelessWidget {
  final String title;
  final String selectedValue;
  final List<String> options;

  MediaQualitySheet({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.options,
  });

  static Future<String?> open({
    required BuildContext context,
    required String selectedValue,
    String title = 'Media Quality',
    List<String>? options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.42,
      ),
      builder: (BuildContext context) {
        return MediaQualitySheet(
          title: title,
          selectedValue: selectedValue,
          options: options ??
              [
                'Data Saver',
                'Balanced',
                'High Quality',
              ],
        );
      },
    );
  }

  String _translatedTitle(String value) {
    switch (value.trim().toLowerCase()) {
      case 'media quality':
        return 'media_quality'.tr;

      case 'keep media':
        return 'keep_media'.tr;

      default:
        return value;
    }
  }

  String _translatedOption(String value) {
    switch (value.trim().toLowerCase()) {
      case 'data saver':
        return 'data_saver'.tr;

      case 'balanced':
        return 'balanced'.tr;

      case 'high quality':
        return 'high_quality'.tr;

      case '3 days':
        return 'three_days'.tr;

      case '1 week':
        return 'one_week'.tr;

      case '1 month':
        return 'one_month'.tr;

      case 'forever':
        return 'forever'.tr;

      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color sheetColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        20,
      ),
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(
                alpha: 0.28,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Text(
                  _translatedTitle(title),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Tooltip(
                message: 'close'.tr,
                child: Material(
                  color: colorScheme.surfaceContainerHighest,
                  shape: CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    customBorder: CircleBorder(),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.close_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          ...options.map(
                (String option) {
              bool selected =
                  option == selectedValue;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: 7,
                ),
                child: Material(
                  color: selected
                      ? colorScheme.primary.withValues(
                    alpha: 0.10,
                  )
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(
                        option,
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: 52,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _translatedOption(option),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: selected
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),

                          if (selected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}