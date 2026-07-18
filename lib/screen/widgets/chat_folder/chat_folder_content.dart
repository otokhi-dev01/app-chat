import 'package:flutter/material.dart';

import '../../../../models/chat_folder_model.dart';
import 'chat_folder_card.dart';
import 'chat_folder_title.dart';

class ChatFolderContent
    extends StatelessWidget {
  final List<ChatFolderModel> folders;
  final VoidCallback onAddFolder;

  final ValueChanged<ChatFolderModel>
  onEditFolder;

  final ValueChanged<ChatFolderModel>
  onDeleteFolder;

  ChatFolderContent({
    super.key,
    required this.folders,
    required this.onAddFolder,
    required this.onEditFolder,
    required this.onDeleteFolder,
  });

  List<ChatFolderModel>
  get defaultFolders {
    return folders
        .where(
          (ChatFolderModel folder) {
        return folder.isSystem;
      },
    )
        .toList();
  }

  List<ChatFolderModel>
  get customFolders {
    return folders
        .where(
          (ChatFolderModel folder) {
        return !folder.isSystem;
      },
    )
        .toList();
  }

  List<Widget> _buildFolderItems({
    required List<ChatFolderModel>
    folderList,
    required ValueChanged<ChatFolderModel>
    onEdit,
    required ValueChanged<ChatFolderModel>
    onDelete,
  }) {
    return List<Widget>.generate(
      folderList.length,
          (int index) {
        ChatFolderModel folder =
        folderList[index];

        return Column(
          children: [
            ChatFolderTile(
              folder: folder,
              onEdit: () {
                onEdit(folder);
              },
              onDelete: () {
                onDelete(folder);
              },
            ),
            if (index <
                folderList.length - 1)
              ChatFolderDivider(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,
      physics: BouncingScrollPhysics(
        parent:
        AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        18,
        16,
        34,
      ),
      children: [
        ChatFolderHeaderCard(
          folderCount: folders.length,
        ),

        SizedBox(height: 24),

        ChatFolderSectionTitle(
          title: 'Default Folders',
        ),

        SizedBox(height: 9),

        ChatFolderCard(
          children: _buildFolderItems(
            folderList: defaultFolders,
            onEdit: onEditFolder,
            onDelete: onDeleteFolder,
          ),
        ),

        SizedBox(height: 24),

        ChatFolderSectionTitle(
          title: 'Custom Folders',
        ),

        SizedBox(height: 9),

        if (customFolders.isNotEmpty)
          ChatFolderCard(
            children: _buildFolderItems(
              folderList: customFolders,
              onEdit: onEditFolder,
              onDelete: onDeleteFolder,
            ),
          )
        else
          _EmptyCustomFoldersCard(
            onCreateFolder: onAddFolder,
          ),

        SizedBox(height: 16),

        OutlinedButton.icon(
          onPressed: onAddFolder,
          icon: Icon(
            Icons.create_new_folder_outlined,
          ),
          label: Text(
            'Create New Folder',
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(
              double.infinity,
              52,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(16),
            ),
          ),
        ),

        SizedBox(height: 18),

        ChatFolderInformationCard(),
      ],
    );
  }
}

class _EmptyCustomFoldersCard
    extends StatelessWidget {
  final VoidCallback onCreateFolder;

  _EmptyCustomFoldersCard({
    required this.onCreateFolder,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness ==
            Brightness.dark;

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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withValues(
                alpha: 0.10,
              ),
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.folder_open_outlined,
              color: colorScheme.primary,
              size: 27,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'No custom folders',
            style: theme
                .textTheme.titleMedium
                ?.copyWith(
              color:
              colorScheme.onSurface,
              fontWeight:
              FontWeight.w700,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Create a folder to organize work, family, school or other conversations.',
            textAlign: TextAlign.center,
            style: theme
                .textTheme.bodySmall
                ?.copyWith(
              color: colorScheme
                  .onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreateFolder,
            icon: Icon(
              Icons.add_rounded,
              size: 19,
            ),
            label: Text(
              'Create Folder',
            ),
            style: FilledButton.styleFrom(
              minimumSize: Size(
                180,
                46,
              ),
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}