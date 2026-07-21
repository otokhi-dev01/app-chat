import 'dart:io';

import 'package:flutter/material.dart';

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
                          groupImagePath.trim().isNotEmpty
                      ? (groupImagePath.startsWith('http://') ||
                              groupImagePath.startsWith('https://')
                          ? Image.network(
                              groupImagePath.trim(),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.image_not_supported_outlined,
                                color: colorScheme.primary,
                                size: 18,
                              ),
                            )
                          : groupImagePath.startsWith('assets/')
                              ? Image.asset(
                                  groupImagePath.trim(),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                    Icons.image_not_supported_outlined,
                                    color: colorScheme.primary,
                                    size: 18,
                                  ),
                                )
                              : Image.file(
                                  File(groupImagePath.trim()),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                    Icons.image_not_supported_outlined,
                                    color: colorScheme.primary,
                                    size: 18,
                                  ),
                                ))
                      : Icon(
                          Icons.add_a_photo_outlined,
                          color: colorScheme.primary,
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
                        'Group Photo',
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
                        'Choose a group profile photo',
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
                  child: InkWell(
                    onTap: () {
                      Navigator.of(
                        sheetContext,
                      ).pop();
                    },
                    customBorder: CircleBorder(),
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
              ],
            ),
            SizedBox(height: 15),
            Column(
              children: [
                _PhotoOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () {
                    _closeAndRun(
                      context: sheetContext,
                      action: onGallery,
                    );
                  },
                ),
                SizedBox(height: 10),
                _PhotoOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
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
                    icon: Icons.delete_outline_rounded,
                    label: 'Remove',
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
            color: isDark ? Color(0xFF22242B) : Color(0xFFF5F7FA),
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant.withValues(
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