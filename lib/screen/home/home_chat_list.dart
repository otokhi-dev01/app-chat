import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../models/chat_folder_model.dart';
import '../../models/chat_model.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../widgets/home/home_chat_archived_tile.dart';
import '../widgets/home/home_chat_state_views.dart';
import '../widgets/home/home_chat_tile.dart';

class HomeChatList extends StatefulWidget {
  final ChatController controller;

  HomeChatList({
    super.key,
    required this.controller,
  });

  @override
  State<HomeChatList> createState() => _HomeChatListState();
}

class _HomeChatListState extends State<HomeChatList> {
  bool _isArchivedVisible = false;

  ChatController get controller => widget.controller;

  // ── Navigation ──────────────────────────────────────────────────────────

  Future<void> _openChat(ChatModel chat) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (chat.unread > 0) {
      await controller.markAsRead(chat.id);
    }

    await Get.to(
      () => ChatDetailScreen(chat: chat),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 280),
    );
  }

  // ── Chat actions ────────────────────────────────────────────────────────

  void _archiveChat(BuildContext context, ChatModel chat) {
    HapticFeedback.lightImpact();
    controller.archiveChat(chat.id);

    _showSnackBar(context, '${chat.name} archived');
  }


  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: isError ? colorScheme.onError : colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isError ? colorScheme.error : colorScheme.primary,
          margin: const EdgeInsets.all(14),
          duration: const Duration(milliseconds: 1800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ── Scroll handling ──────────────────────────────────────────────────────

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      controller.handleChatScroll(notification);
    }

    if (notification is ScrollUpdateNotification) {
      double pixels = notification.metrics.pixels;
      double? scrollDelta = notification.scrollDelta;

      if (scrollDelta != null &&
          scrollDelta > 2.0 &&
          _isArchivedVisible &&
          pixels > 0) {
        setState(() => _isArchivedVisible = false);
      } else {
        double overscroll = -pixels;
        if (overscroll > 20.0 ||
            (scrollDelta != null &&
                scrollDelta < -10.0 &&
                pixels <= 0)) {
          if (!_isArchivedVisible) {
            setState(() => _isArchivedVisible = true);
          }
        }
      }
    } else if (notification is OverscrollNotification) {
      if (notification.overscroll < 0 && !_isArchivedVisible) {
        setState(() => _isArchivedVisible = true);
      }
    }

    return false;
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<ChatModel> visibleChats = controller.filteredChats;

        ChatFolderType selectedFolderType =
            controller.selectedFolderType.value;

        bool hasArchivedChats = selectedFolderType == ChatFolderType.all &&
            controller.archivedChatCount > 0;

        bool showArchivedTile = hasArchivedChats && _isArchivedVisible;

        if (controller.isLoading.value && controller.chats.isEmpty) {
          return HomeChatLoadingView();
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.chats.isEmpty) {
          return HomeChatErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.retry,
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: RefreshIndicator(
            onRefresh: controller.refreshChats,
            child: CustomScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                if (hasArchivedChats)
                  SliverToBoxAdapter(
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: showArchivedTile
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox(height: 0),
                      secondChild: HomeChatArchivedTile(
                        count: controller.archivedChatCount,
                        onTap: controller.openArchivedChatsScreen,
                      ),
                    ),
                  ),

                if (visibleChats.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: HomeChatEmptyView(
                      folderType: selectedFolderType,
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        ChatModel chat = visibleChats[index];

                        return HomeChatTileWrapper(
                          key: ValueKey<String>('home-chat-${chat.id}'),
                          chat: chat,
                          onTap: () => _openChat(chat),
                          onArchive: () => _archiveChat(context, chat),
                          onPin: () {
                            controller.togglePin(chat.id);
                            _showSnackBar(
                              context,
                              chat.isPinned
                                  ? '${chat.name} unpinned'
                                  : '${chat.name} pinned',
                            );
                          },
                          onMuteToggle: () {
                            controller.toggleMute(chat.id);
                            _showSnackBar(
                              context,
                              chat.isMuted
                                  ? '${chat.name} unmuted'
                                  : '${chat.name} muted',
                            );
                          },
                          onMarkRead: () {
                            if (chat.unread > 0) {
                              controller.markAsRead(chat.id);
                              _showSnackBar(
                                context,
                                '${chat.name} marked as read',
                              );
                            } else {
                              controller.markAsUnread(chat.id);
                              _showSnackBar(
                                context,
                                '${chat.name} marked as unread',
                              );
                            }
                          },
                          onDelete: () {
                            controller.deleteChat(chat.id);
                            _showSnackBar(
                              context,
                              '${chat.name} deleted',
                              isError: true,
                            );
                          },
                        );
                      },
                      childCount: visibleChats.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),
              ],
            ),
          ),
        );
      },
    );
  }
}