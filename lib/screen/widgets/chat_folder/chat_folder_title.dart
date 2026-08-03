import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/chat_folder_model.dart';

class ChatFolderTile extends StatelessWidget {
  final ChatFolderModel folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ChatFolderTile({
    super.key,
    required this.folder,
    required this.onEdit,
    required this.onDelete,
  });

  IconData get folderIcon {
    switch (folder.type) {
      case ChatFolderType.all:
        return CupertinoIcons.chat_bubble_2;
      case ChatFolderType.personal:
        return CupertinoIcons.person;
      case ChatFolderType.custom:
        return CupertinoIcons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Row(
          children: [
            _ChatFolderIcon(
              icon: folderIcon,
              custom: !folder.isSystem,
            ),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folder.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    folder.isSystem
                        ? 'default_folder'.tr
                        : 'custom_folder'.tr,
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
            SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(minWidth: 30),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                folder.chatCount.toString(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 4),
            if (folder.isSystem)
              SizedBox(
                width: 38,
                height: 38,
                child: Icon(
                  CupertinoIcons.lock,
                  color: colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              )
            else
              PopupMenuButton<String>(
                tooltip: 'folder_options'.tr,
                padding: EdgeInsets.zero,
                color: isDark ? Color(0xFF24272E) : Colors.white,
                elevation: 10,
                shadowColor: Colors.black.withValues(
                  alpha: isDark ? 0.35 : 0.12,
                ),
                icon: Icon(
                  CupertinoIcons.ellipsis,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                onSelected: (String value) {
                  if (value == 'edit') {
                    onEdit();
                    return;
                  }
                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.pencil,
                            size: 18,
                            color: colorScheme.onSurface,
                          ),
                          SizedBox(width: 12),
                          Text('edit_folder'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.trash,
                            color: colorScheme.error,
                            size: 18,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'delete_folder'.tr,
                            style: TextStyle(
                              color: colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ChatFolderIcon extends StatelessWidget {
  final IconData icon;
  final bool custom;

  const _ChatFolderIcon({
    required this.icon,
    required this.custom,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: 0.11,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: colorScheme.primary,
        size: 20,
      ),
    );
  }
}