import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Future<void> showAddGroupPhotoSheet({
  required BuildContext context,
  required bool hasPhoto,
  String? groupImagePath,
  required VoidCallback onGallery,
  required VoidCallback onCamera,
  required VoidCallback onRemove,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  return showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      return CupertinoActionSheet(
        title: Text(
          'group_photo'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              onGallery();
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
              onCamera();
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
          if (hasPhoto)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(sheetContext);
                onRemove();
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
                  Text('remove'.tr),
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