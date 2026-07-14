import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat_controller.dart';
import '../../models/chat_model.dart';

class SearchScreen extends StatefulWidget {
  final ChatController controller;

  SearchScreen({
    super.key,
    required this.controller,
  });

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController searchTextController;
  late final FocusNode searchFocusNode;

  bool isClosing = false;

  ChatController get controller {
    return widget.controller;
  }

  @override
  void initState() {
    super.initState();

    searchTextController = TextEditingController(
      text: controller.searchQuery.value,
    );

    searchFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || isClosing) {
        return;
      }

      searchFocusNode.requestFocus();
    });
  }

  void _onSearchChanged(String value) {
    controller.updateSearch(value);
  }

  void _clearSearch() {
    if (isClosing) {
      return;
    }

    searchTextController.clear();
    controller.clearSearch();

    if (!searchFocusNode.hasFocus) {
      searchFocusNode.requestFocus();
    }
  }

  Future<bool> _prepareToClose() async {
    if (isClosing) {
      return false;
    }

    isClosing = true;

    searchFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    // Allow the keyboard dismissal animation to begin before closing.
    await Future<void>.delayed(
      Duration(milliseconds: 120),
    );

    controller.clearSearch();

    return true;
  }

  Future<void> _closeSearch() async {
    bool canClose = await _prepareToClose();

    if (!canClose || !mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  String _formatDate(DateTime dateTime) {
    DateTime now = DateTime.now();

    bool isToday =
        now.year == dateTime.year &&
            now.month == dateTime.month &&
            now.day == dateTime.day;

    if (isToday) {
      String hour = dateTime.hour
          .toString()
          .padLeft(2, '0');

      String minute = dateTime.minute
          .toString()
          .padLeft(2, '0');

      return '$hour:$minute';
    }

    DateTime yesterday = now.subtract(
      Duration(days: 1),
    );

    bool isYesterday =
        yesterday.year == dateTime.year &&
            yesterday.month == dateTime.month &&
            yesterday.day == dateTime.day;

    if (isYesterday) {
      return 'Yesterday';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return WillPopScope(
      onWillPop: _prepareToClose,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:
        theme.scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 4,
          backgroundColor: appBarColor,
          foregroundColor: colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            tooltip: 'Back',
            onPressed: _closeSearch,
            icon: Icon(
              Icons.arrow_back_rounded,
            ),
          ),
          title: TextField(
            controller: searchTextController,
            focusNode: searchFocusNode,
            onChanged: _onSearchChanged,
            textInputAction:
            TextInputAction.search,
            keyboardType: TextInputType.text,
            enableSuggestions: true,
            autocorrect: true,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search chats',
              hintStyle: TextStyle(
                color:
                colorScheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 14,
              ),
            ),
            onTapOutside: (PointerDownEvent event) {
              searchFocusNode.unfocus();
            },
          ),
          actions: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable:
              searchTextController,
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

                return IconButton(
                  tooltip: 'Clear search',
                  onPressed: _clearSearch,
                  icon: Icon(
                    Icons.close_rounded,
                  ),
                );
              },
            ),
            SizedBox(width: 4),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: dividerColor,
            ),
          ),
        ),
        body: Obx(
              () {
            if (controller.isLoading.value &&
                controller.chats.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              );
            }

            if (controller
                .errorMessage.value.isNotEmpty &&
                controller.chats.isEmpty) {
              return _SearchErrorWidget(
                message:
                controller.errorMessage.value,
                onRetry: controller.loadChats,
              );
            }

            String query =
            controller.searchQuery.value.trim();

            List<ChatModel> chats =
                controller.filteredChats;

            if (query.isEmpty) {
              return _SearchStatusWidget(
                icon: Icons.search_rounded,
                title: 'Search your conversations',
                message:
                'Search by chat name or message.',
              );
            }

            if (chats.isEmpty) {
              return _SearchStatusWidget(
                icon: Icons.search_off_rounded,
                title: 'No chats found',
                message:
                'Try another name or message.',
              );
            }

            return ListView.separated(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
              physics: BouncingScrollPhysics(
                parent:
                AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.only(
                top: 8,
                bottom: 30,
              ),
              itemCount: chats.length,
              separatorBuilder: (
                  BuildContext context,
                  int index,
                  ) {
                return Divider(
                  height: 1,
                  indent: 76,
                  endIndent: 16,
                  color: dividerColor,
                );
              },
              itemBuilder: (
                  BuildContext context,
                  int index,
                  ) {
                ChatModel chat = chats[index];

                return _SearchChatTile(
                  key: ValueKey(chat.id),
                  chat: chat,
                  formattedDate: _formatDate(
                    chat.dateTime,
                  ),
                  onTap: () {
                    searchFocusNode.unfocus();
                    controller.markAsRead(chat.id);

                    // Add chat-detail navigation here.
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
  final String formattedDate;
  final VoidCallback onTap;

  _SearchChatTile({
    super.key,
    required this.chat,
    required this.formattedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    String name = chat.name.trim();

    String firstLetter = name.isEmpty
        ? '?'
        : name[0].toUpperCase();

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      onTap: onTap,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: colorScheme.primary
                .withValues(alpha: 0.15),
            child: Text(
              firstLetter,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (chat.isOnline)
            Positioned(
              right: 0,
              bottom: 1,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: Color(0xFF32C766),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? Color(0xFF1B1D22)
                        : Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: chat.unread > 0
              ? FontWeight.w700
              : FontWeight.w600,
        ),
      ),
      subtitle: Text(
        chat.isTyping
            ? 'Typing...'
            : chat.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: chat.isTyping
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.end,
        children: [
          Text(
            formattedDate,
            style: TextStyle(
              color: chat.unread > 0
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
          if (chat.unread > 0) ...[
            SizedBox(height: 5),
            Container(
              constraints: BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 5,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Text(
                chat.unread > 99
                    ? '99+'
                    : '${chat.unread}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchStatusWidget
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  _SearchStatusWidget({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus
            ?.unfocus();
      },
      child: Center(
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
                  color: colorScheme.primary
                      .withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 42,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: 18),
              Text(
                title,
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
                message,
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.bodyMedium
                    ?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchErrorWidget
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  _SearchErrorWidget({
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
              Icons.error_outline_rounded,
              size: 54,
              color: colorScheme.error,
            ),
            SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh_rounded,
              ),
              label: Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}