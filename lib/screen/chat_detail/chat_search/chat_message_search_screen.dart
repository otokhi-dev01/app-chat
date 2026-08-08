import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/chat_message_model.dart';
import 'chat_message_search_utils.dart';
import 'chat_search_empty_state.dart';
import 'chat_search_result.dart';

class ChatMessageSearchScreen extends StatefulWidget {
  final String chatName;
  final List<ChatMessageModel> messages;

  const ChatMessageSearchScreen({
    super.key,
    required this.chatName,
    required this.messages,
  });

  @override
  State<ChatMessageSearchScreen> createState() {
    return _ChatMessageSearchScreenState();
  }
}

class _ChatMessageSearchScreenState extends State<ChatMessageSearchScreen> {
  late final TextEditingController searchController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String value = searchController.text.trim().toLowerCase();
    if (value == searchQuery) return;

    setState(() {
      searchQuery = value;
    });
  }

  void _clearSearch() {
    HapticFeedback.lightImpact();
    searchController.clear();
  }

  List<ChatMessageModel> get filteredMessages {
    if (searchQuery.isEmpty) return [];

    return widget.messages.where((ChatMessageModel message) {
      String searchableText =
      ChatMessageSearchUtils.getSearchableText(message).toLowerCase();
      return searchableText.contains(searchQuery);
    }).toList();
  }

  SystemUiOverlayStyle _getOverlayStyle({
    required ThemeData theme,
    required bool isDark,
  }) {
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

  void _selectMessage(ChatMessageModel message) {
    HapticFeedback.lightImpact();
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop(message.id);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color actionBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    SystemUiOverlayStyle overlayStyle = _getOverlayStyle(
      theme: theme,
      isDark: isDark,
    );

    List<ChatMessageModel> results = filteredMessages;
    final double topSpace = MediaQuery.of(context).padding.top + 122;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 60,
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
          systemOverlayStyle: overlayStyle,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: appBarColor,
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
            padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: actionBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pop();
                },
                child: Icon(
                  CupertinoIcons.chevron_left,
                  size: 20,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          title: Text(
            'Search messages',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(62),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: actionBackground,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                          alpha: isDark ? 0.15 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  cursorColor: colorScheme.primary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search in ${widget.chatName}',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                    suffixIcon: searchQuery.isNotEmpty
                        ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(32, 32),
                      onPressed: _clearSearch,
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                        size: 18,
                      ),
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: EdgeInsets.only(top: topSpace),
            child:
            _buildBody(context, results, cardColor, borderColor, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      List<ChatMessageModel> results,
      Color cardColor,
      Color borderColor,
      bool isDark,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    if (searchQuery.isEmpty) {
      return ChatSearchEmptyState(
        icon: CupertinoIcons.search,
        title: 'Search messages',
        message:
        'Search text, photos, voice messages, files, or locations in ${widget.chatName}.',
        iconColor: colorScheme.primary,
      );
    }

    if (results.isEmpty) {
      return ChatSearchEmptyState(
        icon: CupertinoIcons.search,
        title: 'No messages found',
        message: 'Try another word or message type.',
        iconColor: colorScheme.primary,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              ChatMessageModel message = results[index];

              return ChatSearchResultTile(
                key: ValueKey(message.id),
                message: message,
                query: searchQuery,
                preview: ChatMessageSearchUtils.getMessagePreview(message),
                dateText: ChatMessageSearchUtils.formatDate(message.sentAt),
                icon: ChatMessageSearchUtils.getMessageIcon(message.type),
                cardColor: cardColor,
                borderColor: borderColor,
                isDark: isDark,
                onTap: () => _selectMessage(message),
              );
            },
          ),
        ),
      ],
    );
  }
}