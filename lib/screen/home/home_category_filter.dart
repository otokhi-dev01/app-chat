import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/chat/chat_controller.dart';
import '../../../controllers/settings/chat_folder_controller.dart';
import '../../../models/chat_folder_model.dart';

class HomeCategoryFilter extends StatelessWidget {
  final ChatController controller;

  HomeCategoryFilter({
    super.key,
    required this.controller,
  });

  ChatFolderController get folderController {
    return Get.find<ChatFolderController>();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark =
        theme.brightness == Brightness.dark;

    return Obx(
          () {
        List<ChatFolderModel> folders =
        folderController.folders.toList();

        String activeFolderId =
            controller.selectedFolderId.value;

        if (folderController.isLoading.value &&
            folders.isEmpty) {
          return _FolderFilterLoading(
            isDark: isDark,
          );
        }

        if (folders.isEmpty) {
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            2,
            12,
            4,
          ),
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: Container(
                height: 48,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? Color(0xFF17212B)
                      .withValues(
                    alpha: 0.45,
                  )
                      : Colors.white.withValues(
                    alpha: 0.50,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(
                      alpha: 0.08,
                    )
                        : Colors.black.withValues(
                      alpha: 0.05,
                    ),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha:
                        isDark ? 0.15 : 0.04,
                      ),
                      blurRadius: 12,
                      offset: Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),
                child: ListView.separated(
                  scrollDirection:
                  Axis.horizontal,
                  physics:
                  BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,
                  padding: EdgeInsets.zero,
                  itemCount: folders.length,
                  separatorBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    return SizedBox(width: 4);
                  },
                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    ChatFolderModel folder =
                    folders[index];

                    bool isActive =
                        activeFolderId ==
                            folder.id;

                    int count =
                    controller.getFolderCount(
                      folder,
                    );

                    return _CategoryItem(
                      label: folder.name,
                      count: count,
                      isActive: isActive,
                      isDark: isDark,
                      isCustom:
                      !folder.isSystem,
                      onTap: () {
                        if (isActive) {
                          return;
                        }

                        controller.selectFolder(
                          folder,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final bool isDark;
  final bool isCustom;
  final VoidCallback onTap;

  _CategoryItem({
    required this.label,
    required this.count,
    required this.isActive,
    required this.isDark,
    required this.isCustom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    Color primaryColor =
        colorScheme.primary;

    Color inactiveTextColor = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    Color textColor = isActive
        ? primaryColor
        : inactiveTextColor;

    Color itemBackground = isActive
        ? primaryColor.withValues(
      alpha: isDark ? 0.18 : 0.12,
    )
        : isDark
        ? Colors.white.withValues(
      alpha: 0.06,
    )
        : Colors.grey.shade100;

    return Material(
      color: itemBackground,
      borderRadius:
      BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor:
        Colors.transparent,
        focusColor:
        Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 82,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? primaryColor.withValues(
                alpha: 0.18,
              )
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              if (isCustom) ...[
                Icon(
                  Icons.folder_outlined,
                  size: 14,
                  color: textColor,
                ),
                SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    height: 1,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (count > 0) ...[
                SizedBox(width: 5),
                Container(
                  constraints: BoxConstraints(
                    minWidth: 20,
                  ),
                  height: 20,
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: count > 99
                        ? 5
                        : 4,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                    color: isActive
                        ? primaryColor.withValues(
                      alpha: 0.18,
                    )
                        : isDark
                        ? Colors.white
                        .withValues(
                      alpha: 0.10,
                    )
                        : Colors
                        .grey.shade200,
                  ),
                  child: Text(
                    count > 99
                        ? '99+'
                        : '$count',
                    style: TextStyle(
                      color: textColor,
                      fontSize:
                      count > 99 ? 8 : 9,
                      height: 1,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderFilterLoading
    extends StatelessWidget {
  final bool isDark;

  _FolderFilterLoading({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        2,
        12,
        4,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark
              ? Color(0xFF17212B).withValues(
            alpha: 0.45,
          )
              : Colors.white.withValues(
            alpha: 0.50,
          ),
          borderRadius:
          BorderRadius.circular(20),
        ),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
          ),
        ),
      ),
    );
  }
}