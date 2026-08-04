import 'dart:io';

import 'package:flutter/cupertino.dart';
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

  bool isDark = theme.brightness == Brightness.dark;

  Color sheetColor = isDark ? Color(0xFF1B1D22) : Colors.white;

  Color borderColor = isDark
      ? Colors.white.withValues(
    alpha: 0.08,
  )
      : Colors.black.withValues(
    alpha: 0.06,
  );

  Color actionBackground = isDark
      ? Colors.white.withValues(
    alpha: 0.08,
  )
      : Color(0xFFF2F4F7);

  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.38,
    ),
    builder: (
        BuildContext sheetContext,
        ) {
      return Material(
        color: sheetColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PhotoSheetHandle(),

                SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: hasPhoto &&
                          groupImagePath != null &&
                          groupImagePath.trim().isNotEmpty
                          ? _GroupPhotoPreview(
                        imagePath: groupImagePath.trim(),
                      )
                          : Icon(
                        CupertinoIcons.camera,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'group_photo'.tr,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 2),

                          Text(
                            'choose_group_profile_photo'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Unit Close Button UI
                    Container(
                      width: 36,
                      height: 36,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: actionBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor,
                          width: 1.0,
                        ),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(36, 36),
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                        },
                        child: Icon(
                          CupertinoIcons.xmark,
                          size: 18,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Column(
                  children: [
                    _PhotoOption(
                      icon: CupertinoIcons.photo,
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
                      icon: CupertinoIcons.camera,
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
                        icon: CupertinoIcons.trash,
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
          ),
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

class _GroupPhotoPreview extends StatelessWidget {
  final String imagePath;

  const _GroupPhotoPreview({
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
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget errorWidget = Icon(
      CupertinoIcons.photo,
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

class _PhotoSheetHandle extends StatelessWidget {
  const _PhotoSheetHandle();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant.withValues(
          alpha: 0.28,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final VoidCallback onTap;

  const _PhotoOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color foregroundColor =
    isDanger ? colorScheme.error : colorScheme.onSurface;

    Color iconColor = isDanger ? colorScheme.error : colorScheme.primary;

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
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1B1D22) : Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(13),
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: isDanger
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.45,
                ),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}