import 'dart:io';

import 'package:appchat/screen/widgets/profile/edit/photo_option_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showProfilePhotoSheet({
  required BuildContext context,
  String? profileImagePath,
  required VoidCallback onViewPhoto,
  required VoidCallback onTakePhoto,
  required VoidCallback onChooseGallery,
  required VoidCallback onRemovePhoto,
}) {
  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;
  bool isDark = theme.brightness == Brightness.dark;

  Color sheetColor = isDark ? Color(0xFF1B1D22) : Colors.white;

  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Container(
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.25,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: profileImagePath != null &&
                          profileImagePath.trim().isNotEmpty
                          ? (profileImagePath.startsWith('http://') ||
                          profileImagePath.startsWith('https://')
                          ? Image.network(
                        profileImagePath.trim(),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(
                              CupertinoIcons.photo,
                              color: colorScheme.primary,
                            ),
                      )
                          : profileImagePath.startsWith('assets/')
                          ? Image.asset(
                        profileImagePath.trim(),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                            Icon(
                              CupertinoIcons.photo,
                              color: colorScheme.primary,
                            ),
                      )
                          : Image.file(
                        File(profileImagePath.trim()),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                            Icon(
                              CupertinoIcons.photo,
                              color: colorScheme.primary,
                            ),
                      ))
                          : Icon(
                        CupertinoIcons.camera,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'profile_photo'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(32, 32),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                if (profileImagePath != null &&
                    profileImagePath.trim().isNotEmpty) ...[
                  PhotoOptionTile(
                    icon: CupertinoIcons.eye,
                    title: 'view_photo'.tr,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onViewPhoto();
                    },
                  ),
                  SizedBox(height: 8),
                ],
                PhotoOptionTile(
                  icon: CupertinoIcons.camera,
                  title: 'take_photo'.tr,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onTakePhoto();
                  },
                ),
                SizedBox(height: 8),
                PhotoOptionTile(
                  icon: CupertinoIcons.photo,
                  title: 'choose_from_gallery'.tr,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onChooseGallery();
                  },
                ),
                if (profileImagePath != null &&
                    profileImagePath.trim().isNotEmpty) ...[
                  SizedBox(height: 8),
                  PhotoOptionTile(
                    icon: CupertinoIcons.trash,
                    title: 'remove_photo'.tr,
                    isDanger: true,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onRemovePhoto();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}