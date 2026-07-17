import 'package:flutter/material.dart';

Future<void> showSavedMessageDeleteSheet({
  required BuildContext context,
  required VoidCallback onDelete,
}) async {
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

  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.42,
    ),
    builder: (
        BuildContext sheetContext,
        ) {
      return Material(
        color: cardColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          side: BorderSide(
            color: borderColor,
          ),
        ),
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
              Container(
                width: 42,
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
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.error
                          .withValues(
                        alpha: 0.11,
                      ),
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: colorScheme.error,
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delete message?',
                          style: theme
                              .textTheme.titleMedium
                              ?.copyWith(
                            color:
                            colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'This message will be removed permanently.',
                          style: theme
                              .textTheme.bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Divider(
                height: 1,
                color: borderColor,
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: isDark
                          ? Colors.white
                          .withValues(
                        alpha: 0.07,
                      )
                          : Color(0xFFF2F4F7),
                      borderRadius:
                      BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(
                            sheetContext,
                          ).pop();
                        },
                        borderRadius:
                        BorderRadius.circular(16),
                        child: SizedBox(
                          height: 52,
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: colorScheme
                                    .onSurface,
                                fontSize: 14,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Material(
                      color: colorScheme.error,
                      borderRadius:
                      BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(
                            sheetContext,
                          ).pop();

                          onDelete();
                        },
                        borderRadius:
                        BorderRadius.circular(16),
                        child: SizedBox(
                          height: 52,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              Icon(
                                Icons
                                    .delete_outline_rounded,
                                color: colorScheme
                                    .onError,
                                size: 20,
                              ),

                              SizedBox(width: 7),

                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: colorScheme
                                      .onError,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}