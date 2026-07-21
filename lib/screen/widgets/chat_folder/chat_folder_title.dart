import 'package:flutter/material.dart';

import '../../../../models/chat_folder_model.dart';

class ChatFolderTile extends StatelessWidget {
  final ChatFolderModel folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ChatFolderTile({
    super.key,
    required this.folder,
    required this.onEdit,
    required this.onDelete,
  });

  IconData get folderIcon {
    switch (folder.type) {
      case ChatFolderType.all:
        return Icons.chat_bubble_outline_rounded;

      case ChatFolderType.personal:
        return Icons.person_outline_rounded;

      case ChatFolderType.custom:
        return Icons.folder_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          14,
          12,
          8,
          12,
        ),
        child: Row(
          children: [
            _ChatFolderIcon(
              icon: folderIcon,
              custom:
              !folder.isSystem,
            ),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    folder.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow:
                    TextOverflow.visible,
                    style: theme
                        .textTheme.bodyLarge
                        ?.copyWith(
                      color: colorScheme
                          .onSurface,
                      fontWeight:
                      FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    folder.isSystem
                        ? 'Default folder'
                        : 'Custom folder',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: theme
                        .textTheme.bodySmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(
                minWidth: 30,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.09,
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Text(
                folder.chatCount.toString(),
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color:
                  colorScheme.primary,
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 4),
            if (folder.isSystem)
              SizedBox(
                width: 38,
                height: 38,
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: colorScheme
                      .onSurfaceVariant,
                  size: 18,
                ),
              )
            else
              PopupMenuButton<String>(
                tooltip: 'Folder options',
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme
                      .onSurfaceVariant,
                  size: 21,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                onSelected: (
                    String value,
                    ) {
                  if (value == 'edit') {
                    onEdit();
                    return;
                  }

                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder:
                    (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text('Edit folder'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color:
                            colorScheme.error,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Delete folder',
                            style: TextStyle(
                              color:
                              colorScheme.error,
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

  _ChatFolderIcon({
    required this.icon,
    required this.custom,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: custom
            ? colorScheme.primary
            .withValues(
          alpha: 0.14,
        )
            : colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: custom
            ? colorScheme.primary
            : colorScheme
            .onSurfaceVariant,
        size: 21,
      ),
    );
  }
}