import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyOptionsSheet {
  PrivacyOptionsSheet._();

  static Future<String?> open({
    required BuildContext context,
    required String title,
    required String selectedValue,
    required List<String> options,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    String translatedTitle(String value) {
      switch (value.trim().toLowerCase()) {
        case 'phone number':
          return 'phone_number'.tr;
        case 'last seen & online':
          return 'last_seen_and_online'.tr;
        case 'profile photos':
          return 'profile_photos'.tr;
        case 'calls':
          return 'calls'.tr;
        case 'groups & channels':
          return 'groups_and_channels'.tr;
        case 'two-step verification':
          return 'two_step_verification'.tr;
        case 'delete account if away for':
          return 'delete_account_if_away_for'.tr;
        default:
          return value;
      }
    }

    String translatedOption(String value) {
      switch (value.trim().toLowerCase()) {
        case 'everybody':
          return 'everybody'.tr;
        case 'my contacts':
          return 'my_contacts'.tr;
        case 'nobody':
          return 'nobody'.tr;
        case 'on':
          return 'on'.tr;
        case 'off':
          return 'off'.tr;
        case '1 month':
          return 'one_month'.tr;
        case '3 months':
          return 'three_months'.tr;
        case '6 months':
          return 'six_months'.tr;
        case '1 year':
          return 'one_year'.tr;
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
          actions: options.map((String option) {
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