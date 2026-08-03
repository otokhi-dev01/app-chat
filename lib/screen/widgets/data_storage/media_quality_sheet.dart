import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaQualitySheet extends StatelessWidget {
  final String title;
  final String selectedValue;
  final List<String> options;

  const MediaQualitySheet({
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
      useSafeArea: false,
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

    bool isDark = theme.brightness == Brightness.dark;

    Color sheetColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color actionBackground = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    return Material(
      color: sheetColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            18,
            12,
            18,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.28,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // Unit Close Button UI
                  Container(
                    width: 36,
                    height: 36,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: actionBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: 1.0,
                      ),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(36, 36),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 18,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              ...options.map(
                    (String option) {
                  bool selected = option == selectedValue;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Material(
                      color: selected
                          ? colorScheme.primary.withValues(
                        alpha: 0.11,
                      )
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(option);
                        },
                        borderRadius: BorderRadius.circular(18),
                        splashColor: colorScheme.primary.withValues(alpha: 0.12),
                        highlightColor: colorScheme.primary.withValues(alpha: 0.06),
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: 52,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
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
                                    fontSize: 15,
                                  ),
                                ),
                              ),

                              if (selected)
                                Icon(
                                  CupertinoIcons.checkmark,
                                  color: colorScheme.primary,
                                  size: 20,
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
        ),
      ),
    );
  }
}