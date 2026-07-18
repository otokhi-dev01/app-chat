import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../models/chat_folder_model.dart';
import '../../models/chat_model.dart';
import '../chat_detail/chat_detail_screen.dart';

class HomeChatList extends StatelessWidget {
  final ChatController controller;

  HomeChatList({
    super.key,
    required this.controller,
  });

  Future<void> _openChat(
      ChatModel chat,
      ) async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    if (chat.unread > 0) {
      await controller.markAsRead(
        chat.id,
      );
    }

    await Get.to(
          () => ChatDetailScreen(
        chat: chat,
      ),
      transition: Transition.cupertino,
      duration: Duration(
        milliseconds: 280,
      ),
    );
  }

  bool _handleScrollNotification(
      ScrollNotification notification,
      ) {
    if (notification
    is UserScrollNotification) {
      controller.handleChatScroll(
        notification,
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        List<ChatModel> visibleChats =
            controller.filteredChats;

        ChatFolderType selectedFolderType =
            controller
                .selectedFolderType.value;

        bool showArchivedChats =
            selectedFolderType ==
                ChatFolderType.all &&
                controller.archivedChatCount > 0;

        if (controller.isLoading.value &&
            controller.chats.isEmpty) {
          return _ChatLoadingView();
        }

        if (controller
            .errorMessage.value.isNotEmpty &&
            controller.chats.isEmpty) {
          return _ChatErrorView(
            message:
            controller.errorMessage.value,
            onRetry: controller.retry,
          );
        }

        return NotificationListener<
            ScrollNotification>(
          onNotification:
          _handleScrollNotification,
          child: RefreshIndicator(
            onRefresh:
            controller.refreshChats,
            child: CustomScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
              physics:
              BouncingScrollPhysics(
                parent:
                AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                if (showArchivedChats)
                  SliverToBoxAdapter(
                    child: _ArchivedChatsTile(
                      count: controller
                          .archivedChatCount,
                      onTap: controller
                          .openArchivedChatsScreen,
                    ),
                  ),

                if (visibleChats.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyFolderView(
                      folderType:
                      selectedFolderType,
                    ),
                  )
                else
                  SliverList(
                    delegate:
                    SliverChildBuilderDelegate(
                          (
                          BuildContext context,
                          int index,
                          ) {
                        ChatModel chat =
                        visibleChats[index];

                        return Column(
                          children: [
                            _HomeChatTile(
                              chat: chat,
                              onTap: () {
                                _openChat(
                                  chat,
                                );
                              },
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              indent: 82,
                              endIndent: 14,
                              color: Theme.of(
                                context,
                              )
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(
                                alpha:
                                0.35,
                              ),
                            ),
                          ],
                        );
                      },
                      childCount:
                      visibleChats.length,
                    ),
                  ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  _HomeChatTile({
    required this.chat,
    required this.onTap,
  });

  String _formatTime(
      DateTime dateTime,
      ) {
    DateTime now = DateTime.now();

    bool isToday =
        now.year == dateTime.year &&
            now.month == dateTime.month &&
            now.day == dateTime.day;

    if (isToday) {
      String hour =
      dateTime.hour.toString().padLeft(
        2,
        '0',
      );

      String minute =
      dateTime.minute.toString().padLeft(
        2,
        '0',
      );

      return '$hour:$minute';
    }

    DateTime startOfToday = DateTime(
      now.year,
      now.month,
      now.day,
    );

    DateTime startOfMessageDay =
    DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    int difference = startOfToday
        .difference(startOfMessageDay)
        .inDays;

    if (difference == 1) {
      return 'Yesterday';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  IconData get fallbackIcon {
    if (chat.type == 'group') {
      return Icons.groups_rounded;
    }

    return Icons.person_rounded;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    bool hasImage =
        chat.image.trim().isNotEmpty;

    Color pressedColor =
    theme.brightness ==
        Brightness.dark
        ? Colors.white.withValues(
      alpha: 0.04,
    )
        : Colors.black.withValues(
      alpha: 0.025,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        overlayColor:
        WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return pressedColor;
            }

            return Colors.transparent;
          },
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            10,
            14,
            10,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                    colorScheme
                        .surfaceContainerHighest,
                    backgroundImage: hasImage
                        ? NetworkImage(
                      chat.image,
                    )
                        : null,
                    child: hasImage
                        ? null
                        : Icon(
                      fallbackIcon,
                      color: colorScheme
                          .onSurfaceVariant,
                      size: 26,
                    ),
                  ),
                  if (chat.isOnline &&
                      chat.type ==
                          'personal')
                    Positioned(
                      right: 0,
                      bottom: 1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration:
                        BoxDecoration(
                          color:
                          Colors.green,
                          shape:
                          BoxShape.circle,
                          border: Border.all(
                            color: theme
                                .scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: theme
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              color: colorScheme
                                  .onSurface,
                              fontSize: 15,
                              fontWeight:
                              chat.unread >
                                  0
                                  ? FontWeight
                                  .w700
                                  : FontWeight
                                  .w600,
                            ),
                          ),
                        ),
                        if (chat.isPinned)
                          Padding(
                            padding:
                            EdgeInsets.only(
                              left: 5,
                            ),
                            child: Icon(
                              Icons
                                  .push_pin_rounded,
                              color: colorScheme
                                  .onSurfaceVariant,
                              size: 15,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        if (chat.isMuted)
                          Padding(
                            padding:
                            EdgeInsets.only(
                              right: 5,
                            ),
                            child: Icon(
                              Icons
                                  .volume_off_rounded,
                              color: colorScheme
                                  .onSurfaceVariant,
                              size: 15,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            chat.message,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: chat.unread >
                                  0
                                  ? colorScheme
                                  .onSurface
                                  : colorScheme
                                  .onSurfaceVariant,
                              fontSize: 13,
                              fontWeight:
                              chat.unread >
                                  0
                                  ? FontWeight
                                  .w500
                                  : FontWeight
                                  .w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize:
                MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(
                      chat.dateTime,
                    ),
                    style: theme
                        .textTheme.bodySmall
                        ?.copyWith(
                      color: chat.unread > 0
                          ? colorScheme.primary
                          : colorScheme
                          .onSurfaceVariant,
                      fontSize: 11,
                      fontWeight:
                      chat.unread > 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 7),
                  if (chat.unread > 0)
                    Container(
                      constraints:
                      BoxConstraints(
                        minWidth: 21,
                        minHeight: 21,
                      ),
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      alignment:
                      Alignment.center,
                      decoration:
                      BoxDecoration(
                        color: chat.isMuted
                            ? colorScheme
                            .onSurfaceVariant
                            : colorScheme
                            .primary,
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: Text(
                        chat.unread > 99
                            ? '99+'
                            : chat.unread
                            .toString(),
                        style: TextStyle(
                          color: chat.isMuted
                              ? theme
                              .scaffoldBackgroundColor
                              : colorScheme
                              .onPrimary,
                          fontSize: 9,
                          height: 1,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: 21,
                      height: 21,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchivedChatsTile
    extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  _ArchivedChatsTile({
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        4,
      ),
      child: Material(
        color: colorScheme
            .surfaceContainerHighest
            .withValues(
          alpha: 0.45,
        ),
        borderRadius:
        BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          splashColor:
          Colors.transparent,
          highlightColor:
          Colors.transparent,
          borderRadius:
          BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment:
                  Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme
                        .primary
                        .withValues(
                      alpha: 0.12,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      13,
                    ),
                  ),
                  child: Icon(
                    Icons
                        .archive_outlined,
                    color: colorScheme
                        .primary,
                    size: 21,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Archived Chats',
                    style: theme
                        .textTheme.bodyLarge
                        ?.copyWith(
                      color: colorScheme
                          .onSurface,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  constraints:
                  BoxConstraints(
                    minWidth: 28,
                  ),
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  alignment:
                  Alignment.center,
                  decoration:
                  BoxDecoration(
                    color: colorScheme
                        .primary
                        .withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: colorScheme
                          .primary,
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons
                      .chevron_right_rounded,
                  color: colorScheme
                      .onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFolderView
    extends StatelessWidget {
  final ChatFolderType folderType;

  _EmptyFolderView({
    required this.folderType,
  });

  String get title {
    switch (folderType) {
      case ChatFolderType.all:
        return 'No chats yet';

      case ChatFolderType.unread:
        return 'No unread chats';

      case ChatFolderType.personal:
        return 'No personal chats';

      case ChatFolderType.groups:
        return 'No group chats';

      case ChatFolderType.custom:
        return 'No chats in this folder';
    }
  }

  String get subtitle {
    switch (folderType) {
      case ChatFolderType.all:
        return 'Start a conversation and it will appear here.';

      case ChatFolderType.unread:
        return 'You have read all your messages.';

      case ChatFolderType.personal:
        return 'Your personal conversations will appear here.';

      case ChatFolderType.groups:
        return 'Your group conversations will appear here.';

      case ChatFolderType.custom:
        return 'Add conversations to this custom folder.';
    }
  }

  IconData get icon {
    switch (folderType) {
      case ChatFolderType.all:
        return Icons
            .chat_bubble_outline_rounded;

      case ChatFolderType.unread:
        return Icons
            .mark_chat_read_outlined;

      case ChatFolderType.personal:
        return Icons
            .person_outline_rounded;

      case ChatFolderType.groups:
        return Icons.groups_outlined;

      case ChatFolderType.custom:
        return Icons
            .folder_open_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color:
                colorScheme.primary,
                size: 34,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
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
              subtitle,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme.bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatLoadingView
    extends StatelessWidget {
  _ChatLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: Theme.of(context)
            .colorScheme
            .primary,
      ),
    );
  }
}

class _ChatErrorView
    extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  _ChatErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 52,
            ),
            SizedBox(height: 14),
            Text(
              'Unable to load chats',
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
              maxLines: 3,
              overflow:
              TextOverflow.ellipsis,
              style: theme
                  .textTheme.bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
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
            ),
          ],
        ),
      ),
    );
  }
}