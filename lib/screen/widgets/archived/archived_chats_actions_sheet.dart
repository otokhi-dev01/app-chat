import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';

class ArchivedChatActionsSheet {
  ArchivedChatActionsSheet._();

  /// Opens the native iOS Cupertino action sheet and returns after user action.
  static Future<void> show({
    required BuildContext context,
    required ChatModel chat,
    required VoidCallback onUnarchive,
    required VoidCallback onMuteToggle,
    required VoidCallback onDelete,
  }) async {
    HapticFeedback.lightImpact();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return CupertinoActionSheet(
          title: Text(
            chat.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          message: Text(
            'archived_conversation'.tr,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onUnarchive();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.archivebox,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text('unarchive'.tr),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onMuteToggle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    chat.isMuted ? CupertinoIcons.bell : CupertinoIcons.bell_slash,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    chat.isMuted
                        ? 'unmute_notifications'.tr
                        : 'mute_notifications'.tr,
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onDelete();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: CupertinoColors.destructiveRed,
                  ),
                  SizedBox(width: 8),
                  Text('delete_chat'.tr),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop();
            },
            child: Text('cancel'.tr),
          ),
        );
      },
    );
  }
}