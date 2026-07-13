import 'package:appchat/screen/widgets/profile/photo_option_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
Future<void> showProfilePhotoSheet({
  required BuildContext context,
  required VoidCallback onTakePhoto,
  required VoidCallback onChooseGallery,
  required VoidCallback onRemovePhoto,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final bool isDark = theme.brightness == Brightness.dark;

  final Color sheetColor = isDark
      ? const Color(0xFF1B1D22)
      : Colors.white;

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
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
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

                const SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        color: colorScheme.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'profile_photo'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    IconButton(
                      tooltip: 'close'.tr,
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                PhotoOptionTile(
                  icon: Icons.camera_alt_outlined,
                  title: 'take_photo'.tr,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onTakePhoto();
                  },
                ),

                const SizedBox(height: 8),

                PhotoOptionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'choose_from_gallery'.tr,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onChooseGallery();
                  },
                ),

                const SizedBox(height: 8),

                PhotoOptionTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'remove_photo'.tr,
                  isDanger: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onRemovePhoto();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}