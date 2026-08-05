import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Future<void> showChatAttachmentSheet({
  required BuildContext context,
  VoidCallback? onGallery,
  VoidCallback? onCamera,
  VoidCallback? onFile,
  VoidCallback? onLocation,
}) {
  FocusManager.instance.primaryFocus?.unfocus();

  return showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      return CupertinoActionSheet(
        title: Text(
          'share_content'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              if (onGallery != null) {
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onGallery,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.photo,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('gallery'.tr),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              if (onCamera != null) {
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onCamera,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.camera,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('camera'.tr),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              if (onFile != null) {
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onFile,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.doc_text,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('file'.tr),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              if (onLocation != null) {
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onLocation,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.location_solid,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('location'.tr),
              ],
            ),
          ),
        ],
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