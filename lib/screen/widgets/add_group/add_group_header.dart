import 'dart:io';

import 'package:flutter/material.dart';

class AddGroupHeader extends StatelessWidget {
  final TextEditingController nameController;
  final String groupImagePath;
  final VoidCallback onPhotoTap;
  final VoidCallback onRemovePhoto;

  AddGroupHeader({
    super.key,
    required this.nameController,
    required this.groupImagePath,
    required this.onPhotoTap,
    required this.onRemovePhoto,
  });

  bool get hasImage {
    return groupImagePath.trim().isNotEmpty;
  }

  bool get isNetworkImage {
    return groupImagePath.startsWith(
      'http://',
    ) ||
        groupImagePath.startsWith(
          'https://',
        );
  }

  bool get isAssetImage {
    return groupImagePath.startsWith(
      'assets/',
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          17,
        ),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          _GroupPhoto(
            groupImagePath: groupImagePath,
            hasImage: hasImage,
            isNetworkImage: isNetworkImage,
            isAssetImage: isAssetImage,
            onPhotoTap: onPhotoTap,
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: nameController,
              textCapitalization:
              TextCapitalization.words,
              textInputAction:
              TextInputAction.done,
              maxLength: 50,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                labelText: 'Group name',
                hintText: 'Enter group name',
                counterText: '',
                isDense: true,
                filled: true,
                fillColor: colorScheme
                    .surfaceContainerHighest
                    .withValues(
                  alpha: isDark ? 0.42 : 0.55,
                ),
                contentPadding:
                EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.groups_outlined,
                  color: colorScheme
                      .onSurfaceVariant,
                  size: 20,
                ),
                prefixIconConstraints:
                BoxConstraints(
                  minWidth: 42,
                  minHeight: 42,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                  borderSide: BorderSide.none,
                ),
                enabledBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                  borderSide: BorderSide(
                    color: colorScheme
                        .outlineVariant
                        .withValues(
                      alpha: 0.30,
                    ),
                  ),
                ),
                focusedBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupPhoto extends StatelessWidget {
  final String groupImagePath;
  final bool hasImage;
  final bool isNetworkImage;
  final bool isAssetImage;
  final VoidCallback onPhotoTap;

  _GroupPhoto({
    required this.groupImagePath,
    required this.hasImage,
    required this.isNetworkImage,
    required this.isAssetImage,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPhotoTap,
            customBorder: CircleBorder(),
            splashColor: Colors.transparent,
            highlightColor:
            Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: Container(
              width: 56,
              height: 56,
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.11,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary
                      .withValues(
                    alpha: 0.20,
                  ),
                ),
              ),
              child: hasImage
                  ? _GroupImage(
                groupImagePath:
                groupImagePath,
                isNetworkImage:
                isNetworkImage,
                isAssetImage:
                isAssetImage,
              )
                  : Icon(
                Icons.add_a_photo_outlined,
                color: colorScheme.primary,
                size: 23,
              ),
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Material(
            color: colorScheme.primary,
            shape: CircleBorder(),
            child: InkWell(
              onTap: onPhotoTap,
              customBorder: CircleBorder(),
              splashColor: Colors.transparent,
              highlightColor:
              Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: SizedBox(
                width: 22,
                height: 22,
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: colorScheme.onPrimary,
                  size: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GroupImage extends StatelessWidget {
  final String groupImagePath;
  final bool isNetworkImage;
  final bool isAssetImage;

  _GroupImage({
    required this.groupImagePath,
    required this.isNetworkImage,
    required this.isAssetImage,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    if (isNetworkImage) {
      return Image.network(
        groupImagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return _ImageError(
            colorScheme: colorScheme,
          );
        },
      );
    }

    if (isAssetImage) {
      return Image.asset(
        groupImagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return _ImageError(
            colorScheme: colorScheme,
          );
        },
      );
    }

    return Image.file(
      File(groupImagePath),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
          ) {
        return _ImageError(
          colorScheme: colorScheme,
        );
      },
    );
  }
}

class _ImageError extends StatelessWidget {
  final ColorScheme colorScheme;

  _ImageError({
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: colorScheme.primary.withValues(
        alpha: 0.10,
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colorScheme.primary,
        size: 22,
      ),
    );
  }
}