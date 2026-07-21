import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/chat_folder_controller.dart';
import '../../../models/chat_folder_model.dart';
import '../../widgets/chat_folder/chat_folder_content.dart';
import '../../widgets/chat_folder/chat_folder_form_sheet.dart';
import '../../widgets/chat_folder/delete_chat_folder_sheet.dart';
import 'chat_folder_app_bar.dart';

class ChatFolderScreen extends StatelessWidget {
  ChatFolderScreen({
    super.key,
  });

  ChatFolderController get controller {
    return Get.find<ChatFolderController>();
  }

  Future<void> _createFolder(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    ChatFolderFormResult? result =
    await ChatFolderFormSheet.open(
      context: context,
      title: 'Create Folder',
      confirmText: 'Create',
    );

    if (result == null ||
        result.name.trim().isEmpty) {
      return;
    }

    bool created =
    await controller.addFolder(
      result.name,
      chatIds: result.selectedMemberIds,
    );

    if (!context.mounted) {
      return;
    }

    if (!created) {
      _showMessage(
        context: context,
        message:
        controller.errorMessage.value.isEmpty
            ? 'Unable to create folder.'
            : controller.errorMessage.value,
        isError: true,
      );

      return;
    }

    _showMessage(
      context: context,
      message:
      'Folder created successfully.',
    );
  }

  Future<void> _editFolder({
    required BuildContext context,
    required ChatFolderModel folder,
  }) async {
    if (folder.isSystem) {
      _showMessage(
        context: context,
        message:
        'Default folders cannot be edited.',
        isError: true,
      );

      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    ChatFolderFormResult? result =
    await ChatFolderFormSheet.open(
      context: context,
      title: 'Edit Folder',
      confirmText: 'Save',
      initialValue: folder.name,
      initialSelectedMemberIds: folder.chatIds,
    );

    if (result == null ||
        result.name.trim().isEmpty) {
      return;
    }

    String newName = result.name.trim();

    if (newName == folder.name.trim()) {
      return;
    }

    bool updated =
    await controller.updateFolder(
      folderId: folder.id,
      name: newName,
    );

    if (!context.mounted) {
      return;
    }

    if (!updated) {
      _showMessage(
        context: context,
        message:
        controller.errorMessage.value.isEmpty
            ? 'Unable to update folder.'
            : controller.errorMessage.value,
        isError: true,
      );

      return;
    }

    _showMessage(
      context: context,
      message:
      'Folder updated successfully.',
    );
  }

  Future<void> _deleteFolder({
    required BuildContext context,
    required ChatFolderModel folder,
  }) async {
    if (folder.isSystem) {
      _showMessage(
        context: context,
        message:
        'Default folders cannot be deleted.',
        isError: true,
      );

      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    bool? confirmed =
    await DeleteChatFolderSheet.open(
      context: context,
      folderName: folder.name,
    );

    if (confirmed != true) {
      return;
    }

    bool deleted =
    await controller.deleteFolder(
      folder.id,
    );

    if (!context.mounted) {
      return;
    }

    if (!deleted) {
      _showMessage(
        context: context,
        message:
        controller.errorMessage.value.isEmpty
            ? 'Unable to delete folder.'
            : controller.errorMessage.value,
        isError: true,
      );

      return;
    }

    _showMessage(
      context: context,
      message:
      'Folder deleted successfully.',
    );
  }

  void _showMessage({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    Color backgroundColor = isError
        ? colorScheme.error
        : colorScheme.inverseSurface;

    Color foregroundColor = isError
        ? colorScheme.onError
        : colorScheme.onInverseSurface;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
          backgroundColor,
          behavior:
          SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons
                    .error_outline_rounded
                    : Icons
                    .check_circle_outline_rounded,
                color: foregroundColor,
                size: 21,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: ChatFolderAppBar(
        onAdd: () {
          _createFolder(context);
        },
      ),
      body: Obx(
            () {
          if (controller.isLoading.value &&
              controller.folders.isEmpty) {
            return _ChatFolderLoadingView();
          }

          if (controller
              .errorMessage.value.isNotEmpty &&
              controller.folders.isEmpty) {
            return _ChatFolderErrorView(
              message:
              controller.errorMessage.value,
              onRetry:
              controller.loadFolders,
            );
          }

          return ChatFolderContent(
            folders:
            controller.folders.toList(),
            onAddFolder: () {
              _createFolder(context);
            },
            onEditFolder:
                (ChatFolderModel folder) {
              _editFolder(
                context: context,
                folder: folder,
              );
            },
            onDeleteFolder:
                (ChatFolderModel folder) {
              _deleteFolder(
                context: context,
                folder: folder,
              );
            },
          );
        },
      ),
    );
  }
}

class _ChatFolderLoadingView
    extends StatelessWidget {
  _ChatFolderLoadingView();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: colorScheme.primary,
      ),
    );
  }
}

class _ChatFolderErrorView
    extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  _ChatFolderErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.error
                    .withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 31,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Unable to load folders',
              textAlign: TextAlign.center,
              style: theme
                  .textTheme.titleMedium
                  ?.copyWith(
                color:
                colorScheme.onSurface,
                fontWeight:
                FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme.bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
                height: 1.4,
              ),
            ),
            SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () {
                onRetry();
              },
              icon: Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                'Try Again',
              ),
              style:
              FilledButton.styleFrom(
                minimumSize:
                Size(160, 48),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}