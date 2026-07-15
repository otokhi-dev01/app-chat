import 'package:flutter/material.dart';

import 'chat_attachment_item.dart';

Future<void> showChatAttachmentSheet({
  required BuildContext context,
  VoidCallback? onGallery,
  VoidCallback? onCamera,
  VoidCallback? onFile,
  VoidCallback? onLocation,
}) {
  FocusManager.instance.primaryFocus?.unfocus();

  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;

  bool isDark =
      theme.brightness == Brightness.dark;

  Color sheetColor = isDark
      ? Color(0xFF1B1D22)
      : Colors.white;

  Color borderColor = isDark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.06);

  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor:
    Colors.black.withValues(alpha: 0.35),
    builder: (BuildContext sheetContext) {
      return Container(
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
          border: Border(
            top: BorderSide(
              color: borderColor,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHandle(),

                SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary
                            .withValues(alpha: 0.11),
                        borderRadius:
                        BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.attach_file_rounded,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Share content',
                        style: theme
                            .textTheme.titleMedium
                            ?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: [
                    ChatAttachmentItem(
                      icon: Icons.image_outlined,
                      label: 'Gallery',
                      onTap: () {
                        _closeAndRun(
                          sheetContext,
                          onGallery,
                        );
                      },
                    ),
                    ChatAttachmentItem(
                      icon:
                      Icons.camera_alt_outlined,
                      label: 'Camera',
                      onTap: () {
                        _closeAndRun(
                          sheetContext,
                          onCamera,
                        );
                      },
                    ),
                    ChatAttachmentItem(
                      icon: Icons
                          .insert_drive_file_outlined,
                      label: 'File',
                      onTap: () {
                        _closeAndRun(
                          sheetContext,
                          onFile,
                        );
                      },
                    ),
                    ChatAttachmentItem(
                      icon:
                      Icons.location_on_outlined,
                      label: 'Location',
                      onTap: () {
                        _closeAndRun(
                          sheetContext,
                          onLocation,
                        );
                      },
                    ),
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

void _closeAndRun(
    BuildContext context,
    VoidCallback? action,
    ) {
  Navigator.pop(context);

  if (action == null) {
    return;
  }

  Future<void>.delayed(
    Duration(milliseconds: 130),
    action,
  );
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant
            .withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}