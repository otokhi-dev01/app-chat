import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/chat/chat_controller.dart';
import '../../../models/chat_model.dart';
import '../../chat_detail/chat_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  final ChatController controller;

  SearchScreen({
    super.key,
    required this.controller,
  });

  void _closeSearch(
      BuildContext context,
      ) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _clearSearch() {
    controller.clearSearch();
  }

  Future<void> _openChat(
      ChatModel chat,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

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

  SystemUiOverlayStyle _overlayStyle(
      ThemeData theme,
      bool isDark,
      ) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        Brightness.light,
        statusBarBrightness:
        Brightness.dark,
        systemNavigationBarColor:
        theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      Brightness.dark,
      statusBarBrightness:
      Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color headerColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.95,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color searchBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFE7E9ED);

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    return PopScope(
      onPopInvokedWithResult: (
          bool didPop,
          Object? result,
          ) {
        if (didPop) {
          FocusManager.instance.primaryFocus
              ?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:
        theme.scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 68,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor:
          Colors.transparent,
          foregroundColor:
          colorScheme.onSurface,
          surfaceTintColor:
          Colors.transparent,
          shadowColor:
          Colors.transparent,
          forceMaterialTransparency: true,
          titleSpacing: 0,
          leadingWidth: 58,
          systemOverlayStyle:
          _overlayStyle(
            theme,
            isDark,
          ),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: headerColor,
                  border: Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.fromLTRB(
              8,
              12,
              6,
              12,
            ),
            child: Material(
              color: actionBackground,
              shape: CircleBorder(),
              child: Tooltip(
                message: 'Back',
                child: InkWell(
                  onTap: () {
                    _closeSearch(
                      context,
                    );
                  },
                  customBorder:
                  CircleBorder(),
                  splashColor:
                  Colors.transparent,
                  highlightColor:
                  Colors.transparent,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                      size: 18,
                      color: colorScheme
                          .onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: searchBackground,
                borderRadius:
                BorderRadius.circular(
                  16,
                ),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 13),
                  Icon(
                    Icons.search_rounded,
                    size: 21,
                    color:
                    colorScheme.primary,
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: TextField(
                      controller: controller
                          .searchTextController,
                      autofocus: true,
                      onChanged:
                      controller.updateSearch,
                      textInputAction:
                      TextInputAction.search,
                      keyboardType:
                      TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor:
                      colorScheme.primary,
                      style: theme
                          .textTheme.bodyLarge
                          ?.copyWith(
                        color: colorScheme
                            .onSurface,
                        fontSize: 15,
                      ),
                      decoration:
                      InputDecoration(
                        hintText:
                        'Search chats',
                        hintStyle: theme
                            .textTheme.bodyLarge
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                          fontSize: 15,
                        ),
                        border:
                        InputBorder.none,
                        enabledBorder:
                        InputBorder.none,
                        focusedBorder:
                        InputBorder.none,
                        isDense: true,
                        contentPadding:
                        EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                      ),
                      onTapOutside: (
                          PointerDownEvent event,
                          ) {
                        FocusManager.instance
                            .primaryFocus
                            ?.unfocus();
                      },
                    ),
                  ),
                  ValueListenableBuilder<
                      TextEditingValue>(
                    valueListenable: controller
                        .searchTextController,
                    builder: (
                        BuildContext context,
                        TextEditingValue value,
                        Widget? child,
                        ) {
                      if (value.text.isEmpty) {
                        return SizedBox(
                          width: 8,
                        );
                      }

                      return Padding(
                        padding:
                        EdgeInsets.only(
                          right: 4,
                        ),
                        child: Material(
                          color: colorScheme
                              .onSurfaceVariant
                              .withValues(
                            alpha: 0.10,
                          ),
                          shape:
                          CircleBorder(),
                          child: Tooltip(
                            message:
                            'Clear search',
                            child: InkWell(
                              onTap:
                              _clearSearch,
                              customBorder:
                              CircleBorder(),
                              splashColor:
                              Colors
                                  .transparent,
                              highlightColor:
                              Colors
                                  .transparent,
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Icon(
                                  Icons
                                      .close_rounded,
                                  size: 18,
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Obx(
              () {
            String query = controller
                .searchQuery.value
                .trim();

            List<ChatModel> results =
                controller.searchResults;

            if (query.isEmpty) {
              return _SearchInitialView();
            }

            if (results.isEmpty) {
              return _SearchEmptyView(
                query: query,
              );
            }

            return ListView.separated(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
              physics:
              BouncingScrollPhysics(
                parent:
                AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(
                0,
                6,
                0,
                30,
              ),
              itemCount: results.length,
              separatorBuilder: (
                  BuildContext context,
                  int index,
                  ) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  indent: 82,
                  endIndent: 14,
                  color: colorScheme
                      .outlineVariant
                      .withValues(
                    alpha: 0.35,
                  ),
                );
              },
              itemBuilder: (
                  BuildContext context,
                  int index,
                  ) {
                ChatModel chat =
                results[index];

                return _SearchChatTile(
                  chat: chat,
                  onTap: () {
                    _openChat(chat);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SearchChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  _SearchChatTile({
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

    DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    DateTime messageDay = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    int difference =
        today.difference(messageDay).inDays;

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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool hasImage =
        chat.image.trim().isNotEmpty;

    Color pressedColor =
    theme.brightness == Brightness.dark
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
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme
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
                      chat.type == 'personal')
                    Positioned(
                      right: 0,
                      bottom: 1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration:
                        BoxDecoration(
                          color: Colors.green,
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
                          color: colorScheme
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

class _SearchInitialView
    extends StatelessWidget {
  _SearchInitialView();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          28,
          80,
          28,
          40,
        ),
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
                Icons.search_rounded,
                color:
                colorScheme.primary,
                size: 34,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Search chats',
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
              'Search by contact name or message.',
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

class _SearchEmptyView
    extends StatelessWidget {
  final String query;

  _SearchEmptyView({
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          28,
          80,
          28,
          40,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .search_off_rounded,
                color: colorScheme
                    .onSurfaceVariant,
                size: 34,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No results found',
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
              'No chats match “$query”.',
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