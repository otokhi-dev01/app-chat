import 'package:appchat/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../widgets/chat_title.dart';

class HomeChatList extends StatelessWidget {
  final ChatController controller;

  HomeChatList({
    super.key,
    required this.controller,
  });

  String _emptyMessage(int categoryIndex) {
    switch (categoryIndex) {
      case 1:
        return 'No unread conversations';
      case 2:
        return 'No personal conversations';
      case 3:
        return 'No group conversations';
      default:
        return 'No conversations found';
    }
  }

  IconData _emptyIcon(int categoryIndex) {
    switch (categoryIndex) {
      case 1:
        return Icons.mark_chat_read_outlined;
      case 2:
        return Icons.person_outline_rounded;
      case 3:
        return Icons.groups_outlined;
      default:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  Widget _scrollListener({
    required Widget child,
  }) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (
          UserScrollNotification notification,
          ) {
        controller.handleChatScroll(notification);
        return false;
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Obx(() {
      int categoryIndex =
          controller.selectedCategoryIndex.value;

      bool isLoading =
          controller.isLoading.value;

      String errorMessage =
          controller.errorMessage.value;

      List<ChatModel> allChats =
      controller.chats.toList();

      // Important fix:
      List<ChatModel> visibleChats =
          controller.filteredChats;

      if (isLoading && allChats.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        );
      }

      if (errorMessage.isNotEmpty &&
          allChats.isEmpty) {
        return _ChatErrorWidget(
          message: errorMessage,
          onRetry: controller.retry,
        );
      }

      if (visibleChats.isEmpty) {
        return _scrollListener(
          child: RefreshIndicator(
            color: colorScheme.primary,
            onRefresh: controller.refreshChats,
            child: ListView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(
                24,
                130,
                24,
                110,
              ),
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _emptyIcon(categoryIndex),
                      size: 42,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  _emptyMessage(categoryIndex),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Pull down to refresh your conversations.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return _scrollListener(
        child: RefreshIndicator(
          color: colorScheme.primary,
          onRefresh: controller.refreshChats,
          child: ListView.separated(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              top: 6,
              bottom: 105,
            ),
            itemCount: visibleChats.length,
            separatorBuilder: (
                BuildContext context,
                int index,
                ) {
              return Divider(
                height: 1,
                thickness: 1,
                indent: 80,
                endIndent: 16,
                color: colorScheme.outlineVariant.withValues(
                  alpha: 0.45,
                ),
              );
            },
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              ChatModel chat = visibleChats[index];

              return ChatTile(
                key: ValueKey(chat.id),
                chat: chat,
              );
            },
          ),
        ),
      );
    });
  }
}

class _ChatErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  _ChatErrorWidget({
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
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            SizedBox(height: 16),
            Text(
              'Unable to load chats',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh_rounded,
              ),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}