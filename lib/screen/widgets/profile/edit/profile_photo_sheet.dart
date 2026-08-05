import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Future<void> showProfilePhotoSheet({
  required BuildContext context,
  String? profileImagePath,
  required VoidCallback onViewPhoto,
  required VoidCallback onTakePhoto,
  required VoidCallback onChooseGallery,
  required VoidCallback onRemovePhoto,
}) {
  FocusManager.instance.primaryFocus?.unfocus();

  bool hasPhoto = profileImagePath != null && profileImagePath.trim().isNotEmpty;

  return showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      return CupertinoActionSheet(
        title: Text(
          'profile_photo'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (hasPhoto)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                onViewPhoto();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.eye,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text('view_photo'.tr),
                ],
              ),
            ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              onTakePhoto();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.camera,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('take_photo'.tr),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              onChooseGallery();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.photo,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('choose_from_gallery'.tr),
              ],
            ),
          ),
          if (hasPhoto)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(sheetContext);
                onRemovePhoto();
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
                  Text('remove_photo'.tr),
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