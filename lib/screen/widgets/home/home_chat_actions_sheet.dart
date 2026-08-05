import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';

class HomeChatActionsSheet {
  HomeChatActionsSheet._();

  /// Opens the native iOS Cupertino action sheet and returns after user action.
  static Future<void> show({
    required BuildContext context,
    required ChatModel chat,
    required VoidCallback onPin,
    required VoidCallback onMuteToggle,
    required VoidCallback onArchive,
    required VoidCallback onMarkRead,
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
            chat.type == 'group' ? 'group_chat'.tr : 'personal_chat'.tr,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          actions: [
            // Pin / Unpin
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onPin();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    chat.isPinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(chat.isPinned ? 'unpin'.tr : 'pin'.tr),
                ],
              ),
            ),

            // Mute / Unmute
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
                  Text(chat.isMuted ? 'unmute'.tr : 'mute'.tr),
                ],
              ),
            ),

            // Archive
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onArchive();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.archivebox,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text('archive'.tr),
                ],
              ),
            ),

            // Mark Read / Unread
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onMarkRead();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    chat.unread > 0
                        ? CupertinoIcons.checkmark_circle
                        : CupertinoIcons.chat_bubble,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(chat.unread > 0 ? 'mark_as_read'.tr : 'mark_as_unread'.tr),
                ],
              ),
            ),

            // Delete
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