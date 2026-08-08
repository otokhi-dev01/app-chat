import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/chat/chat_controller.dart';
import '../../../models/chat_folder_model.dart';
import '../../../models/chat_model.dart';
import '../../chat_detail/chat_detail_screen.dart';
import '../../widgets/app_feedback.dart'; // Imported AppFeedback
import '../home_chat_archived_tile.dart';
import '../home_chat_state_views.dart';
import '../home_chat_tile.dart';

class HomeChatList extends StatefulWidget {
  final ChatController controller;

  const HomeChatList({
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
      duration: Duration(milliseconds: 280),
    );
  }

  // ── Chat actions ────────────────────────────────────────────────────────

  void _archiveChat(BuildContext context, ChatModel chat) {
    HapticFeedback.lightImpact();
    controller.archiveChat(chat.id);

    AppFeedback.showMessage(
      title: 'archived'.tr,
      message: '${chat.name} ${'was_archived'.tr}',
      icon: CupertinoIcons.archivebox,
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
            (scrollDelta != null && scrollDelta < -10.0 && pixels <= 0)) {
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

        ChatFolderType selectedFolderType = controller.selectedFolderType.value;

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
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                if (hasArchivedChats)
                  SliverToBoxAdapter(
                    child: AnimatedCrossFade(
                      duration: Duration(milliseconds: 250),
                      crossFadeState: showArchivedTile
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: SizedBox(height: 0),
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
                            bool wasPinned = chat.isPinned;
                            controller.togglePin(chat.id);
                            AppFeedback.showMessage(
                              title: wasPinned ? 'unpinned'.tr : 'pinned'.tr,
                              message: wasPinned
                                  ? '${chat.name} ${'was_unpinned'.tr}'
                                  : '${chat.name} ${'was_pinned'.tr}',
                              icon: wasPinned
                                  ? CupertinoIcons.pin
                                  : CupertinoIcons.pin_fill,
                            );
                          },
                          onMuteToggle: () {
                            bool wasMuted = chat.isMuted;
                            controller.toggleMute(chat.id);
                            AppFeedback.showMessage(
                              title: wasMuted ? 'unmuted'.tr : 'muted'.tr,
                              message: wasMuted
                                  ? '${chat.name} ${'was_unmuted'.tr}'
                                  : '${chat.name} ${'was_muted'.tr}',
                              icon: wasMuted
                                  ? CupertinoIcons.bell
                                  : CupertinoIcons.bell_slash_fill,
                            );
                          },
                          onMarkRead: () {
                            if (chat.unread > 0) {
                              controller.markAsRead(chat.id);
                              AppFeedback.showMessage(
                                title: 'marked_as_read'.tr,
                                message: '${chat.name} ${'marked_as_read'.tr}',
                                icon: CupertinoIcons.checkmark_circle,
                              );
                            } else {
                              controller.markAsUnread(chat.id);
                              AppFeedback.showMessage(
                                title: 'marked_as_unread'.tr,
                                message: '${chat.name} ${'marked_as_unread'.tr}',
                                icon: CupertinoIcons.chat_bubble,
                              );
                            }
                          },
                          onDelete: () {
                            controller.deleteChat(chat.id);
                            AppFeedback.showMessage(
                              title: 'deleted'.tr,
                              message: '${chat.name} ${'was_deleted'.tr}',
                              icon: CupertinoIcons.trash,
                            );
                          },
                        );
                      },
                      childCount: visibleChats.length,
                    ),
                  ),

                SliverToBoxAdapter(
                  child: SizedBox(height: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}