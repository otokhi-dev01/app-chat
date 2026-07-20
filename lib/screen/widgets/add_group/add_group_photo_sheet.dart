import 'package:flutter/material.dart';

Future<void> showAddGroupPhotoSheet({
  required BuildContext context,
  required bool hasPhoto,
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
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withValues(
                      alpha: 0.11,
                    ),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Icon(
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
            Row(
              children: [
                Expanded(
                  child: _PhotoOption(
                    icon:
                    Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () {
                      _closeAndRun(
                        context: sheetContext,
                        action: onGallery,
                      );
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _PhotoOption(
                    icon:
                    Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () {
                      _closeAndRun(
                        context: sheetContext,
                        action: onCamera,
                      );
                    },
                  ),
                ),
                if (hasPhoto) ...[
                  SizedBox(width: 8),
                  Expanded(
                    child: _PhotoOption(
                      icon:
                      Icons.delete_outline_rounded,
                      label: 'Remove',
                      isDanger: true,
                      onTap: () {
                        _closeAndRun(
                          context: sheetContext,
                          action: onRemove,
                        );
                      },
                    ),
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
          height: 70,
          padding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
            BorderRadius.circular(15),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: foregroundColor,
                size: 23,
              ),
              SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color: foregroundColor,
                  fontSize: 10.5,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}