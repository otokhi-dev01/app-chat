import 'dart:io';

import 'package:flutter/material.dart';
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

  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;

  bool isDark =
      theme.brightness == Brightness.dark;

  Color sheetColor = isDark
      ? Color(0xFF1B1D22)
      : Colors.white;

  Color borderColor = isDark
      ? Colors.white.withValues(
    alpha: 0.08,
  )
      : Colors.black.withValues(
    alpha: 0.06,
  );

  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.38,
    ),
    builder: (
        BuildContext sheetContext,
        ) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          14,
          9,
          14,
          18,
        ),
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
          ),
          border: Border(
            top: BorderSide(
              color: borderColor,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PhotoSheetHandle(),

            SizedBox(height: 13),

            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withValues(
                      alpha: 0.11,
                    ),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: hasPhoto &&
                      groupImagePath != null &&
                      groupImagePath
                          .trim()
                          .isNotEmpty
                      ? _GroupPhotoPreview(
                    imagePath:
                    groupImagePath.trim(),
                  )
                      : Icon(
                    Icons
                        .add_a_photo_outlined,
                    color:
                    colorScheme.primary,
                    size: 20,
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'group_photo'.tr,
                        style: theme
                            .textTheme.titleSmall
                            ?.copyWith(
                          color:
                          colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        'choose_group_profile_photo'
                            .tr,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme.bodySmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Material(
                  color: colorScheme
                      .surfaceContainerHighest,
                  shape: CircleBorder(),
                  child: Tooltip(
                    message: 'close'.tr,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(
                          sheetContext,
                        ).pop();
                      },
                      customBorder:
                      CircleBorder(),
                      splashColor:
                      Colors.transparent,
                      highlightColor:
                      Colors.transparent,
                      hoverColor:
                      Colors.transparent,
                      focusColor:
                      Colors.transparent,
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.close_rounded,
                          color: colorScheme
                              .onSurfaceVariant,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            Column(
              children: [
                _PhotoOption(
                  icon: Icons
                      .photo_library_outlined,
                  label: 'gallery'.tr,
                  onTap: () {
                    _closeAndRun(
                      context: sheetContext,
                      action: onGallery,
                    );
                  },
                ),

                SizedBox(height: 10),

                _PhotoOption(
                  icon:
                  Icons.camera_alt_outlined,
                  label: 'camera'.tr,
                  onTap: () {
                    _closeAndRun(
                      context: sheetContext,
                      action: onCamera,
                    );
                  },
                ),

                if (hasPhoto) ...[
                  SizedBox(height: 10),

                  _PhotoOption(
                    icon: Icons
                        .delete_outline_rounded,
                    label: 'remove'.tr,
                    isDanger: true,
                    onTap: () {
                      _closeAndRun(
                        context: sheetContext,
                        action: onRemove,
                      );
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _closeAndRun({
  required BuildContext context,
  required VoidCallback action,
}) {
  Navigator.of(context).pop();

  Future<void>.delayed(
    Duration(
      milliseconds: 100,
    ),
    action,
  );
}

class _GroupPhotoPreview
    extends StatelessWidget {
  final String imagePath;

  _GroupPhotoPreview({
    required this.imagePath,
  });

  bool get isNetworkImage {
    return imagePath.startsWith(
      'http://',
    ) ||
        imagePath.startsWith(
          'https://',
        );
  }

  bool get isAssetImage {
    return imagePath.startsWith(
      'assets/',
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    Widget errorWidget = Icon(
      Icons.image_not_supported_outlined,
      color: colorScheme.primary,
      size: 18,
    );

    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return errorWidget;
        },
      );
    }

    if (isAssetImage) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return errorWidget;
        },
      );
    }

    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
          ) {
        return errorWidget;
      },
    );
  }
}

class _PhotoSheetHandle
    extends StatelessWidget {
  _PhotoSheetHandle();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant
            .withValues(
          alpha: 0.25,
        ),
        borderRadius:
        BorderRadius.circular(20),
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final VoidCallback onTap;

  _PhotoOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color foregroundColor = isDanger
        ? colorScheme.error
        : colorScheme.onSurface;

    Color iconColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    Color backgroundColor = isDanger
        ? colorScheme.error.withValues(
      alpha: 0.09,
    )
        : colorScheme.primary.withValues(
      alpha: 0.09,
    );

    Color borderColor = isDanger
        ? colorScheme.error.withValues(
      alpha: 0.16,
    )
        : isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.05,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(15),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? Color(0xFF22242B)
                : Color(0xFFF5F7FA),
            borderRadius:
            BorderRadius.circular(15),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),

              SizedBox(width: 14),

              Expanded(
                child: Text(
                  label,
                  style: theme
                      .textTheme.bodyMedium
                      ?.copyWith(
                    color: foregroundColor,
                    fontSize: 14.5,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme
                    .onSurfaceVariant
                    .withValues(
                  alpha: 0.4,
                ),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}