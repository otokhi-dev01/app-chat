import 'package:flutter/material.dart';

import 'chat_attachment_item.dart';

Future<void> showChatAttachmentSheet({
  required BuildContext context,
  VoidCallback? onGallery,
  VoidCallback? onCamera,
  VoidCallback? onFile,
  VoidCallback? onLocation,
}) {
  FocusManager.instance.primaryFocus
      ?.unfocus();

  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme =
      theme.colorScheme;

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

  Color closeButtonColor = isDark
      ? Colors.white.withValues(
    alpha: 0.08,
  )
      : Colors.black.withValues(
    alpha: 0.04,
  );

  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.35,
    ),
    builder: (
        BuildContext sheetContext,
        ) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius:
          BorderRadius.vertical(
            top: Radius.circular(22),
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
              14,
              9,
              14,
              16,
            ),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                _SheetHandle(),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment:
                      Alignment.center,
                      decoration:
                      BoxDecoration(
                        color: colorScheme
                            .primary
                            .withValues(
                          alpha: 0.11,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          11,
                        ),
                      ),
                      child: Icon(
                        Icons
                            .attach_file_rounded,
                        color:
                        colorScheme.primary,
                        size: 19,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Share content',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme.titleSmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurface,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                    Material(
                      color: closeButtonColor,
                      shape: CircleBorder(),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                          );
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
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                      ChatAttachmentItem(
                        imagePath:
                        'assets/images/chat_attachment/gallery.png',
                        label: 'Gallery',
                        imageSize: 34,
                        onTap: () {
                          _closeAndRun(
                            sheetContext,
                            onGallery,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child:
                      ChatAttachmentItem(
                        imagePath:
                        'assets/images/chat_attachment/camera.png',
                        label: 'Camera',
                        imageSize: 34,
                        onTap: () {
                          _closeAndRun(
                            sheetContext,
                            onCamera,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child:
                      ChatAttachmentItem(
                        imagePath:
                        'assets/images/chat_attachment/file.png',
                        label: 'File',
                        imageSize: 34,
                        onTap: () {
                          _closeAndRun(
                            sheetContext,
                            onFile,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child:
                      ChatAttachmentItem(
                        imagePath:
                        'assets/images/chat_attachment/location.png',
                        label: 'Location',
                        imageSize: 34,
                        onTap: () {
                          _closeAndRun(
                            sheetContext,
                            onLocation,
                          );
                        },
                      ),
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
    Duration(
      milliseconds: 100,
    ),
        () {
      action();
    },
  );
}

class _SheetHandle extends StatelessWidget {
  _SheetHandle();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme
            .onSurfaceVariant
            .withValues(
          alpha: 0.25,
        ),
        borderRadius:
        BorderRadius.circular(20),
      ),
    );
  }
}