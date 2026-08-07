import 'dart:io';

import 'package:flutter/cupertino.dart';
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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    ImageProvider? imageProvider;
    if (profileImagePath.trim().isNotEmpty) {
      String trimmed = profileImagePath.trim();
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
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Color(0xFF1B1D22) : Colors.white,
                border: Border.all(
                  color: borderColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.18 : 0.05,
                    ),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(
                  CupertinoIcons.person_fill,
                  color: colorScheme.primary,
                  size: 64,
                )
                    : null,
              ),
            ),
            Positioned(
              right: -1,
              bottom: 4,
              child: Material(
                color: colorScheme.primary,
                shape: CircleBorder(),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: onChangePhoto,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      CupertinoIcons.camera_fill,
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        TextButton.icon(
          onPressed: onChangePhoto,
          icon: Icon(
            CupertinoIcons.camera,
            size: 18,
          ),
          label: Text(
            'change_profile_photo'.tr,
          ),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}