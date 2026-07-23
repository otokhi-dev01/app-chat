import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final IconData icon;
  final bool isDanger;

  AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.icon,
    this.isDanger = true,
  });

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required IconData icon,
    bool isDanger = true,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AppConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          icon: icon,
          isDanger: isDanger,
        );
      },
    );

    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color actionColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    Color actionForegroundColor = isDanger
        ? colorScheme.onError
        : colorScheme.onPrimary;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return AlertDialog(
      backgroundColor: cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: borderColor,
        ),
      ),
      titlePadding: EdgeInsets.fromLTRB(
        22,
        22,
        22,
        0,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        22,
        14,
        22,
        8,
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        14,
        8,
        14,
        14,
      ),
      title: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: actionColor.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: actionColor,
              size: 22,
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13,
          height: 1.45,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'cancel'.tr,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: FilledButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: actionForegroundColor,
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 11,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: Text(
            confirmText,
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}