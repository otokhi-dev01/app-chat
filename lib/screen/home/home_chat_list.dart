import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../models/chat_model.dart';
import '../widgets/chat_title.dart';

class HomeChatList extends StatelessWidget {
  final ChatController controller;

  final bool isSearchMode;
  final bool enableHomeScrollBehavior;
  final bool enableRefresh;

  final double topPadding;
  final double bottomPadding;
  final double emptyTopPadding;
  final double emptyBottomPadding;

  HomeChatList({
    super.key,
    required this.controller,
    this.isSearchMode = false,
    this.enableHomeScrollBehavior = true,
    this.enableRefresh = true,
    this.topPadding = 6,
    this.bottomPadding = 105,
    this.emptyTopPadding = 130,
    this.emptyBottomPadding = 110,
  });

  String _emptyMessage({
    required int categoryIndex,
    required String query,
  }) {
    if (isSearchMode) {
      if (query.isEmpty) {
        return 'No conversations found';
      }

      return 'No chats found';
    }

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

  String _emptyDescription({
    required String query,
  }) {
    if (isSearchMode) {
      if (query.isEmpty) {
        return 'Your conversations will appear here.';
      }

      return 'Try another chat name or message.';
    }

    return 'Pull down to refresh your conversations.';
  }

  IconData _emptyIcon({
    required int categoryIndex,
    required String query,
  }) {
    if (isSearchMode) {
      if (query.isEmpty) {
        return Icons.chat_bubble_outline_rounded;
      }

      return Icons.search_off_rounded;
    }

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

  Widget _wrapScrollable({
    required Widget child,
  }) {
    Widget result = child;

    if (enableRefresh) {
      result = RefreshIndicator(
        onRefresh: controller.refreshChats,
        child: result,
      );
    }

    if (enableHomeScrollBehavior) {
      result =
          NotificationListener<UserScrollNotification>(
            onNotification: (
                UserScrollNotification notification,
                ) {
              controller.handleChatScroll(
                notification,
              );

              return false;
            },
            child: result,
          );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Obx(
          () {
        int categoryIndex =
            controller.selectedCategoryIndex.value;

        bool isLoading =
            controller.isLoading.value;

        String errorMessage =
            controller.errorMessage.value;

        String query =
        controller.searchQuery.value.trim();

        List<ChatModel> allChats =
        controller.chats.toList();

        List<ChatModel> visibleChats =
        isSearchMode
            ? controller.searchResults
            : controller.filteredChats;

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
          return _wrapScrollable(
            child: ListView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
              physics: BouncingScrollPhysics(
                parent:
                AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(
                24,
                emptyTopPadding,
                24,
                emptyBottomPadding,
              ),
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary
                          .withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _emptyIcon(
                        categoryIndex:
                        categoryIndex,
                        query: query,
                      ),
                      size: 42,
                      color: colorScheme.primary,
                    ),
                  ),
                ),

                SizedBox(height: 18),

                Text(
                  _emptyMessage(
                    categoryIndex:
                    categoryIndex,
                    query: query,
                  ),
                  textAlign: TextAlign.center,
                  style: theme
                      .textTheme.titleMedium
                      ?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 7),

                Text(
                  _emptyDescription(
                    query: query,
                  ),
                  textAlign: TextAlign.center,
                  style: theme
                      .textTheme.bodyMedium
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return _wrapScrollable(
          child: ListView.separated(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior
                .onDrag,
            physics: BouncingScrollPhysics(
              parent:
              AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.only(
              top: topPadding,
              bottom: bottomPadding,
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
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.45),
              );
            },
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              ChatModel chat =
              visibleChats[index];

              return ChatTile(
                key: ValueKey(chat.id),
                chat: chat,
              );
            },
          ),
        );
      },
    );
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
            Container(
              width: 88,
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.error
                    .withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 42,
                color: colorScheme.error,
              ),
            ),

            SizedBox(height: 18),

            Text(
              'Unable to load chats',
              style: theme
                  .textTheme.titleMedium
                  ?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme.bodyMedium
                  ?.copyWith(
                color:
                colorScheme.onSurfaceVariant,
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