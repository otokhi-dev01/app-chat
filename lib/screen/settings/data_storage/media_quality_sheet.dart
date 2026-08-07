import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaQualitySheet {
  MediaQualitySheet._();

  static Future<String?> open({
    required BuildContext context,
    required String selectedValue,
    String title = 'Media Quality',
    List<String>? options,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    List<String> effectiveOptions = options ??
        [
          'Data Saver',
          'Balanced',
          'High Quality',
        ];

    String translatedTitle(String value) {
      switch (value.trim().toLowerCase()) {
        case 'media quality':
          return 'media_quality'.tr;
        case 'keep media':
          return 'keep_media'.tr;
        default:
          return value;
      }
    }

    String translatedOption(String value) {
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

    return showCupertinoModalPopup<String>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(
            translatedTitle(title),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: effectiveOptions.map((String option) {
            bool isSelected = option == selectedValue;

            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext, option);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translatedOption(option),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.checkmark,
                      size: 18,
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
            },
            child: Text('cancel'.tr),
          ),
        );
      },
    );
  }
}