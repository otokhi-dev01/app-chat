import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatCallOptionsSheet {
  ChatCallOptionsSheet._();

  /// Displays the native iOS Cupertino call options action sheet.
  static Future<void> show({
    required BuildContext context,
    VoidCallback? onAudioCall,
    VoidCallback? onVideoCall,
  }) async {
    HapticFeedback.lightImpact();
    FocusManager.instance.primaryFocus?.unfocus();

    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return CupertinoActionSheet(
          title: Text(
            'start_a_call'.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          message: Text(
            'choose_how_you_want_to_call'.tr,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          actions: [
            // Audio Call Action
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                if (onAudioCall != null) {
                  Future<void>.delayed(
                    const Duration(milliseconds: 100),
                    onAudioCall,
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.phone,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('audio_call'.tr),
                ],
              ),
            ),

            // Video Call Action
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                if (onVideoCall != null) {
                  Future<void>.delayed(
                    const Duration(milliseconds: 100),
                    onVideoCall,
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.videocam,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('video_call'.tr),
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