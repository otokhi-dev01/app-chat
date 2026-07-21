import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String profileImagePath;
  final VoidCallback onChangePhoto;

  const ProfileAvatarSection({
    super.key,
    required this.profileImagePath,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    ImageProvider? imageProvider;
    if (profileImagePath.trim().isNotEmpty) {
      final trimmed = profileImagePath.trim();
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        imageProvider = NetworkImage(trimmed);
      } else if (trimmed.startsWith('assets/')) {
        imageProvider = AssetImage(trimmed);
      } else {
        imageProvider = FileImage(File(trimmed));
      }
    }

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 116,
              height: 116,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF1B1D22)
                    : Colors.white,
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(
                        Icons.person_rounded,
                        color: colorScheme.primary,
                        size: 68,
                      )
                    : null,
              ),
            ),

            Positioned(
              right: -1,
              bottom: 4,
              child: Material(
                color: colorScheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onChangePhoto,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        TextButton.icon(
          onPressed: onChangePhoto,
          icon: const Icon(
            Icons.photo_camera_outlined,
            size: 19,
          ),
          label: Text(
            'change_profile_photo'.tr,
          ),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}