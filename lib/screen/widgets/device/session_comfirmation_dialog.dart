import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionConfirmationDialog {
  static Future<bool> showTerminateSession({
    required BuildContext context,
    required String deviceName,
  }) async {
    return _show(
      context: context,
      title: 'terminate_session'.tr,
      message: 'terminate_session_confirmation'.trParams({
        'device': deviceName,
      }),
      icon: Icons.logout_rounded,
    );
  }

  static Future<bool> showTerminateAllSessions({
    required BuildContext context,
  }) async {
    return _show(
      context: context,
      title: 'terminate_all_sessions_title'.tr,
      message: 'terminate_all_sessions_confirmation'.tr,
      icon: Icons.devices_rounded,
    );
  }

  static Future<bool> _show({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        ThemeData theme = Theme.of(dialogContext);
        ColorScheme colorScheme = theme.colorScheme;

        bool isDark =
            theme.brightness == Brightness.dark;

        Color dialogColor = isDark
            ? Color(0xFF1B1D22)
            : Colors.white;

        return AlertDialog(
          backgroundColor: dialogColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
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
                  color: colorScheme.error.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.error,
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
                Navigator.of(dialogContext).pop(false);
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
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(
                'terminate'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    return confirmed == true;
  }
}