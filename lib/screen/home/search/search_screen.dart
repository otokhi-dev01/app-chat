import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/chat/chat_controller.dart';
import '../../../models/chat_model.dart';
import '../../chat_detail/chat_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  final ChatController controller;

  const SearchScreen({
    super.key,
    required this.controller,
  });

  void _closeSearch(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Get.back();
  }

  void _clearSearch() {
    controller.clearSearch();
  }

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

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color headerColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    final Color actionBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color searchBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 68,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          forceMaterialTransparency: true,
          titleSpacing: 0,
          leadingWidth: 58,
          systemOverlayStyle: _overlayStyle(theme, isDark),
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
            padding: const EdgeInsets.fromLTRB(12, 14, 6, 14),
            child: Tooltip(
              message: 'back'.tr,
              child: Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: actionBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.04,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 40),
                  onPressed: () => _closeSearch(context),
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: searchBackground,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.15 : 0.04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    CupertinoIcons.search,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.searchTextController,
                      autofocus: true,
                      onChanged: controller.updateSearch,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor: colorScheme.primary,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'search_chats'.tr,
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : Colors.black.withValues(alpha: 0.4),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 11,
                        ),
                      ),
                      onTapOutside: (PointerDownEvent event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.searchTextController,
                    builder: (
                        BuildContext context,
                        TextEditingValue value,
                        Widget? child,
                        ) {
                      if (value.text.isEmpty) {
                        return const SizedBox(width: 12);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                          onPressed: _clearSearch,
                          child: Icon(
                            CupertinoIcons.xmark_circle_fill,
                            size: 18,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.black.withValues(alpha: 0.4),
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
            String query = controller.searchQuery.value.trim();
            List<ChatModel> results = controller.searchResults;

            if (query.isEmpty) {
              return const _SearchInitialView();
            }

            if (results.isEmpty) {
              return _SearchEmptyView(query: query);
            }

            return ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 30),
              itemCount: results.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  indent: 82,
                  endIndent: 14,
                  color: colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                );
              },
              itemBuilder: (BuildContext context, int index) {
                ChatModel chat = results[index];

                return _SearchChatTile(
                  chat: chat,
                  onTap: () => _openChat(chat),
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

  const _SearchChatTile({
    required this.chat,
    required this.onTap,
  });

  String _formatTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    bool isToday = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      String hour = dateTime.hour.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    int difference = today.difference(messageDay).inDays;

    if (difference == 1) {
      return 'yesterday'.tr;
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  IconData get fallbackIcon {
    if (chat.type == 'group') {
      return CupertinoIcons.person_3_fill;
    }
    return CupertinoIcons.person_fill;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool hasImage = chat.image.trim().isNotEmpty;

    final Color pressedColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.025);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return pressedColor;
            }
            return Colors.transparent;
          },
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    backgroundImage: hasImage ? NetworkImage(chat.image) : null,
                    child: hasImage
                        ? null
                        : Icon(
                      fallbackIcon,
                      color: colorScheme.onSurfaceVariant,
                      size: 26,
                    ),
                  ),
                  if (chat.isOnline && chat.type == 'personal')
                    Positioned(
                      right: 0,
                      bottom: 1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: chat.unread > 0
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (chat.isPinned)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              CupertinoIcons.pin_fill,
                              color: colorScheme.onSurfaceVariant,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        if (chat.isMuted)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(
                              CupertinoIcons.bell_slash_fill,
                              color: colorScheme.onSurfaceVariant,
                              size: 14,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            chat.message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: chat.unread > 0
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(chat.dateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: chat.unread > 0
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight:
                      chat.unread > 0 ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 7),
                  if (chat.unread > 0)
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 21,
                        minHeight: 21,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: chat.isMuted
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        chat.unread > 99 ? '99+' : chat.unread.toString(),
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 9,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    const SizedBox(
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

class _SearchInitialView extends StatelessWidget {
  const _SearchInitialView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 80, 28, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: colorScheme.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'search_chats'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'search_hint_description'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchEmptyView extends StatelessWidget {
  final String query;

  const _SearchEmptyView({
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 80, 28, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: colorScheme.onSurfaceVariant,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'no_results_found'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'no_chats_match'.trParams({'query': query}),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}