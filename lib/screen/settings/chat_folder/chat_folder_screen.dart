import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/chat_folder_controller.dart';
import '../../../models/chat_folder_model.dart';
import 'chat_folder_content.dart';
import '../../widgets/app_feedback.dart';
import 'chat_folder_app_bar.dart';
import 'create_folder_screen.dart';

class ChatFolderScreen extends StatelessWidget {
  const ChatFolderScreen({
    super.key,
  });

  ChatFolderController get controller {
    return Get.find<ChatFolderController>();
  }

  Future<void> _createFolder(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    ChatFolderFormResult? result = await Get.to<ChatFolderFormResult>(
          () => CreateFolderScreen(
        title: 'create_folder'.tr,
        confirmText: 'create'.tr,
        initialValue: '',
      ),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 280),
    );

    if (result == null || result.name.trim().isEmpty) {
      return;
    }

    bool created = await controller.createFolder(
      name: result.name,
      chatIds: result.selectedMemberIds,
    );

    if (!context.mounted) {
      return;
    }

    if (!created) {
      _showMessage(
        message: controller.errorMessage.value.isEmpty
            ? 'unable_to_create_folder'.tr
            : controller.errorMessage.value,
        isError: true,
      );

      return;
    }

    _showMessage(
      title: 'folder_created'.tr,
      message: 'folder_created_successfully'.tr,
    );
  }

  Future<void> _editFolder({
    required BuildContext context,
    required ChatFolderModel folder,
  }) async {
    if (folder.isSystem) {
      _showMessage(
        message: 'default_folders_cannot_be_edited'.tr,
        isError: true,
      );

      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    ChatFolderFormResult? result = await Get.to<ChatFolderFormResult>(
          () => CreateFolderScreen(
        title: 'edit_folder'.tr,
        confirmText: 'save'.tr,
        initialValue: folder.name,
        initialSelectedMemberIds: folder.chatIds,
      ),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 280),
    );

    if (result == null || result.name.trim().isEmpty) {
      return;
    }

    String newName = result.name.trim();

    if (newName == folder.name.trim()) {
      return;
    }

    bool updated = await controller.updateFolder(
      folderId: folder.id,
      name: newName,
    );

    if (!context.mounted) {
      return;
    }

    if (!updated) {
      _showMessage(
        message: controller.errorMessage.value.isEmpty
            ? 'unable_to_update_folder'.tr
            : controller.errorMessage.value,
        isError: true,
      );

      return;
    }

    _showMessage(
      title: 'folder_updated'.tr,
      message: 'folder_updated_successfully'.tr,
    );
  }

  Future<void> _deleteFolder({
    required BuildContext context,
    required ChatFolderModel folder,
  }) async {
    if (folder.isSystem) {
      _showMessage(
        message: 'default_folders_cannot_be_deleted'.tr,
        isError: true,
      );

      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text('delete_folder_question'.tr),
          content: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'delete_folder_desc'.trParams({'name': folder.name}),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text('cancel'.tr),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text('delete'.tr),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    bool deleted = await controller.deleteFolder(
      folder,
    );

    if (!context.mounted) {
      return;
    }

    if (!deleted) {
      _showMessage(
        message: controller.errorMessage.value.isEmpty
            ? 'unable_to_delete_folder'.tr
            : controller.errorMessage.value,
        isError: true,
      );

      return;
    }

    _showMessage(
      title: 'folder_deleted'.tr,
      message: 'folder_deleted_successfully'.tr,
    );
  }

  void _showMessage({
    required String message,
    String? title,
    bool isError = false,
  }) {
    AppFeedback.showMessage(
      title: title ?? (isError ? 'error'.tr : 'success'.tr),
      message: message,
      icon: isError
          ? CupertinoIcons.exclamationmark_circle
          : CupertinoIcons.checkmark_circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChatFolderAppBar(
        onAdd: () {
          _createFolder(context);
        },
      ),
      body: Obx(
            () {
          if (controller.isLoading.value && controller.folders.isEmpty) {
            return _ChatFolderLoadingView();
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.folders.isEmpty) {
            return _ChatFolderErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.loadFolders,
            );
          }

          return ChatFolderContent(
            folders: controller.folders.toList(),
            onAddFolder: () {
              _createFolder(context);
            },
            onEditFolder: (ChatFolderModel folder) {
              _editFolder(
                context: context,
                folder: folder,
              );
            },
            onDeleteFolder: (ChatFolderModel folder) {
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

class _ChatFolderLoadingView extends StatelessWidget {
  const _ChatFolderLoadingView();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: colorScheme.primary,
      ),
    );
  }
}

class _ChatFolderErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ChatFolderErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

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
                color: colorScheme.error.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.exclamationmark_circle,
                color: colorScheme.error,
                size: 31,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'unable_to_load_folders'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () {
                onRetry();
              },
              icon: Icon(
                CupertinoIcons.arrow_clockwise,
                size: 18,
              ),
              label: Text(
                'try_again'.tr,
              ),
              style: FilledButton.styleFrom(
                minimumSize: Size(160, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    16,
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