import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';

/// ADDED: Native iOS CupertinoActionSheet for long-pressing call history logs
class CallActionsSheet {
  CallActionsSheet._();

  /// Displays action sheet when holding/long-pressing a call log entry
  static Future<void> show({
    required BuildContext context,
    required ChatModel call,
    required VoidCallback onAudioCall,
    required VoidCallback onVideoCall,
    required VoidCallback onSendMessage,
    required VoidCallback onDeleteCall,
  }) async {
    HapticFeedback.lightImpact();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        final bool isMissed = call.unread > 0;
        final bool isIncoming = !call.isMe;

        // ADDED: Localized call direction label for action sheet subtitle
        String callTypeLabel = isMissed
            ? 'missed_call'.tr
            : (isIncoming ? 'incoming_call'.tr : 'outgoing_call'.tr);

        return CupertinoActionSheet(
          title: Text(
            call.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          message: Text(
            '$callTypeLabel • ${call.message}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          actions: [
            // 1. Audio Call Action
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onAudioCall();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.phone_fill,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('audio_call'.tr),
                ],
              ),
            ),

            // 2. Video Call Action
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onVideoCall();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.videocam_fill,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('video_call'.tr),
                ],
              ),
            ),

            // 3. Send Message Action
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onSendMessage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.chat_bubble_fill,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('send_message'.tr),
                ],
              ),
            ),

            // 4. Delete Call Log (Destructive Red)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onDeleteCall();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: CupertinoColors.destructiveRed,
                  ),
                  const SizedBox(width: 8),
                  Text('delete_call_log'.tr),
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