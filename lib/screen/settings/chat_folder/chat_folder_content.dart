import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/chat_folder_model.dart';
import 'chat_folder_card.dart';
import 'chat_folder_title.dart';

class ChatFolderContent extends StatelessWidget {
  final List<ChatFolderModel> folders;
  final VoidCallback onAddFolder;
  final ValueChanged<ChatFolderModel> onEditFolder;
  final ValueChanged<ChatFolderModel> onDeleteFolder;

  const ChatFolderContent({
    super.key,
    required this.folders,
    required this.onAddFolder,
    required this.onEditFolder,
    required this.onDeleteFolder,
  });

  List<ChatFolderModel> get defaultFolders {
    return folders.where((ChatFolderModel folder) {
      return folder.isSystem;
    }).toList();
  }

  List<ChatFolderModel> get customFolders {
    return folders.where((ChatFolderModel folder) {
      return !folder.isSystem;
    }).toList();
  }

  List<Widget> _buildFolderItems({
    required List<ChatFolderModel> folderList,
    required ValueChanged<ChatFolderModel> onEdit,
    required ValueChanged<ChatFolderModel> onDelete,
  }) {
    return List<Widget>.generate(
      folderList.length,
          (int index) {
        ChatFolderModel folder = folderList[index];

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
            if (index < folderList.length - 1) ChatFolderDivider(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(16, 18, 16, 34),
      children: [
        ChatFolderHeaderCard(
          folderCount: folders.length,
        ),
        SizedBox(height: 24),
        ChatFolderSectionTitle(
          title: 'default_folders'.tr,
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
          title: 'custom_folders'.tr,
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
            CupertinoIcons.folder_badge_plus,
            size: 20,
          ),
          label: Text(
            'create_new_folder'.tr,
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 52),
            foregroundColor: colorScheme.primary,
            side: BorderSide(
              color: colorScheme.primary.withValues(alpha: 0.35),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        SizedBox(height: 18),
        ChatFolderInformationCard(),
      ],
    );
  }
}

class _EmptyCustomFoldersCard extends StatelessWidget {
  final VoidCallback onCreateFolder;

  const _EmptyCustomFoldersCard({
    required this.onCreateFolder,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              CupertinoIcons.folder,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'no_custom_folders'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'no_custom_folders_desc'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreateFolder,
            icon: Icon(
              CupertinoIcons.plus,
              size: 18,
            ),
            label: Text(
              'create_folder'.tr,
            ),
            style: FilledButton.styleFrom(
              minimumSize: Size(180, 46),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}