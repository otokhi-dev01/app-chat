import 'package:flutter/cupertino.dart';
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
    );
  }

  static Future<bool> showTerminateAllSessions({
    required BuildContext context,
  }) async {
    return _show(
      context: context,
      title: 'terminate_all_sessions_title'.tr,
      message: 'terminate_all_sessions_confirmation'.tr,
    );
  }

  static Future<bool> _show({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: Text(message),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'cancel'.tr,
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                'terminate'.tr,
              ),
            ),
          ],
        );
      },
    );

    return confirmed == true;
  }
}