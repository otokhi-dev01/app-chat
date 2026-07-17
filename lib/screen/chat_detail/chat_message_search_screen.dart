import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/chat_message_model.dart';

class ChatMessageSearchScreen extends StatefulWidget {
  final String chatName;
  final List<ChatMessageModel> messages;

  ChatMessageSearchScreen({
    super.key,
    required this.chatName,
    required this.messages,
  });

  @override
  State<ChatMessageSearchScreen> createState() {
    return _ChatMessageSearchScreenState();
  }
}

class _ChatMessageSearchScreenState
    extends State<ChatMessageSearchScreen> {
  late final TextEditingController searchController;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    searchController.addListener(
      _onSearchChanged,
    );
  }

  void _onSearchChanged() {
    String value =
    searchController.text.trim().toLowerCase();

    if (value == searchQuery) {
      return;
    }

    setState(() {
      searchQuery = value;
    });
  }

  void _clearSearch() {
    searchController.clear();
  }

  List<ChatMessageModel> get filteredMessages {
    if (searchQuery.isEmpty) {
      return [];
    }

    return widget.messages.where(
          (ChatMessageModel message) {
        String searchableText =
        _getSearchableText(message).toLowerCase();

        return searchableText.contains(searchQuery);
      },
    ).toList();
  }

  String _getSearchableText(
      ChatMessageModel message,
      ) {
    List<String> values = [
      message.text,
      _getMessageTypeLabel(message),
      _getFileName(message),
    ];

    if (message.latitude != null &&
        message.longitude != null) {
      values.add(
        '${message.latitude}, ${message.longitude}',
      );
    }

    return values.join(' ');
  }

  String _getMessageTypeLabel(
      ChatMessageModel message,
      ) {
    switch (message.type) {
      case ChatMessageType.text:
        return 'text message';

      case ChatMessageType.image:
        return 'photo image';

      case ChatMessageType.voice:
        return 'voice audio message';

      case ChatMessageType.file:
        return 'file document';

      case ChatMessageType.location:
        return 'location map';
      case ChatMessageType.video:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.contact:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.sticker:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.gif:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.call:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.system:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _getMessagePreview(
      ChatMessageModel message,
      ) {
    String text = message.text.trim();

    switch (message.type) {
      case ChatMessageType.text:
        return text.isEmpty
            ? 'Text message'
            : text;

      case ChatMessageType.image:
        return text.isEmpty
            ? 'Photo'
            : text;

      case ChatMessageType.voice:
        return text.isEmpty
            ? 'Voice message'
            : text;

      case ChatMessageType.file:
        if (text.isNotEmpty) {
          return text;
        }

        String fileName = _getFileName(message);

        return fileName.isEmpty
            ? 'File'
            : fileName;

      case ChatMessageType.location:
        if (text.isNotEmpty) {
          return text;
        }

        if (message.latitude != null &&
            message.longitude != null) {
          return '${message.latitude!.toStringAsFixed(6)}, '
              '${message.longitude!.toStringAsFixed(6)}';
        }

        return 'Shared location';
      case ChatMessageType.video:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.contact:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.sticker:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.gif:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.call:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.system:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _getFileName(
      ChatMessageModel message,
      ) {
    String? mediaPath = message.mediaPath;

    if (mediaPath == null ||
        mediaPath.trim().isEmpty) {
      return '';
    }

    String normalizedPath =
    mediaPath.replaceAll('\\', '/');

    return normalizedPath.split('/').last;
  }

  IconData _getMessageIcon(
      ChatMessageType type,
      ) {
    switch (type) {
      case ChatMessageType.text:
        return Icons.chat_bubble_outline_rounded;

      case ChatMessageType.image:
        return Icons.image_outlined;

      case ChatMessageType.voice:
        return Icons.mic_none_rounded;

      case ChatMessageType.file:
        return Icons.insert_drive_file_outlined;

      case ChatMessageType.location:
        return Icons.location_on_outlined;
      case ChatMessageType.video:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.contact:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.sticker:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.gif:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.call:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ChatMessageType.system:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    String period = hour >= 12 ? 'PM' : 'AM';

    int formattedHour = hour % 12;

    if (formattedHour == 0) {
      formattedHour = 12;
    }

    String formattedMinute =
    minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }

  String _formatDate(DateTime dateTime) {
    DateTime now = DateTime.now();

    bool isToday =
        now.year == dateTime.year &&
            now.month == dateTime.month &&
            now.day == dateTime.day;

    if (isToday) {
      return _formatTime(dateTime);
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

    return '${dateTime.day}/'
        '${dateTime.month}/'
        '${dateTime.year}';
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
        systemNavigationBarColor:
        theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.dark,
    );
  }

  void _selectMessage(
      ChatMessageModel message,
      ) {
    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).pop(message.id);
  }

  @override
  void dispose() {
    searchController.removeListener(
      _onSearchChanged,
    );

    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.94,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    Color searchBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFE7E9ED);

    SystemUiOverlayStyle overlayStyle =
    _getOverlayStyle(
      theme: theme,
      isDark: isDark,
    );

    List<ChatMessageModel> results =
        filteredMessages;

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
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
        leadingWidth: 54,
        systemOverlayStyle: overlayStyle,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
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
          padding: EdgeInsets.fromLTRB(
            8,
            12,
            5,
            12,
          ),
          child: Material(
            color: actionBackground,
            shape: CircleBorder(),
            child: Tooltip(
              message: 'Back',
              child: InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus
                      ?.unfocus();

                  Navigator.of(context).pop();
                },
                customBorder: CircleBorder(),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Search messages',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(66),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              4,
              12,
              12,
            ),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: searchBackground,
                borderRadius:
                BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: searchController,
                autofocus: true,
                textInputAction:
                TextInputAction.search,
                keyboardAppearance: isDark
                    ? Brightness.dark
                    : Brightness.light,
                cursorColor: colorScheme.primary,
                style:
                theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText:
                  'Search in ${widget.chatName}',
                  hintStyle: theme
                      .textTheme.bodyMedium
                      ?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: 3,
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: searchQuery.isEmpty
                          ? colorScheme
                          .onSurfaceVariant
                          : colorScheme.primary,
                      size: 21,
                    ),
                  ),
                  prefixIconConstraints:
                  BoxConstraints(
                    minWidth: 45,
                    minHeight: 48,
                  ),
                  suffixIcon: searchQuery.isEmpty
                      ? null
                      : Padding(
                    padding: EdgeInsets.fromLTRB(
                      3,
                      6,
                      6,
                      6,
                    ),
                    child: Material(
                      color: colorScheme.onSurface
                          .withValues(
                        alpha: 0.08,
                      ),
                      shape: CircleBorder(),
                      child: Tooltip(
                        message: 'Clear',
                        child: InkWell(
                          onTap: _clearSearch,
                          customBorder:
                          CircleBorder(),
                          child: SizedBox(
                            width: 34,
                            height: 34,
                            child: Icon(
                              Icons.close_rounded,
                              color: colorScheme
                                  .onSurfaceVariant,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  suffixIconConstraints:
                  BoxConstraints(
                    minWidth: 45,
                    minHeight: 48,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder:
                  InputBorder.none,
                  isDense: true,
                  contentPadding:
                  EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus
              ?.unfocus();
        },
        child: _buildBody(
          context: context,
          results: results,
          cardColor: cardColor,
          borderColor: borderColor,
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required List<ChatMessageModel> results,
    required Color cardColor,
    required Color borderColor,
  }) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    if (searchQuery.isEmpty) {
      return _SearchMessageState(
        icon: Icons.search_rounded,
        title: 'Search messages',
        message:
        'Search text, photos, voice messages, files, or locations.',
        iconColor: colorScheme.primary,
      );
    }

    if (results.isEmpty) {
      return _SearchMessageState(
        icon: Icons.search_off_rounded,
        title: 'No messages found',
        message:
        'Try another word or message type.',
        iconColor: colorScheme.primary,
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            8,
          ),
          child: Row(
            children: [
              Text(
                '${results.length} result'
                    '${results.length == 1 ? '' : 's'}',
                style:
                theme.textTheme.bodySmall?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior
                .onDrag,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              12,
              0,
              12,
              30,
            ),
            itemCount: results.length,
            separatorBuilder: (
                BuildContext context,
                int index,
                ) {
              return SizedBox(height: 8);
            },
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              ChatMessageModel message =
              results[index];

              return _MessageSearchResultTile(
                key: ValueKey(message.id),
                message: message,
                query: searchQuery,
                preview:
                _getMessagePreview(message),
                dateText:
                _formatDate(message.sentAt),
                icon:
                _getMessageIcon(message.type),
                cardColor: cardColor,
                borderColor: borderColor,
                onTap: () {
                  _selectMessage(message);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MessageSearchResultTile
    extends StatelessWidget {
  final ChatMessageModel message;
  final String query;
  final String preview;
  final String dateText;
  final IconData icon;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;

  _MessageSearchResultTile({
    super.key,
    required this.message,
    required this.query,
    required this.preview,
    required this.dateText,
    required this.icon,
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            12,
            11,
            12,
            11,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(alpha: 0.12),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 23,
                ),
              ),
              SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message.isMe
                                ? 'You'
                                : 'Received',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: theme
                                .textTheme.bodyMedium
                                ?.copyWith(
                              color:
                              colorScheme.onSurface,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          dateText,
                          style: theme
                              .textTheme.bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    _HighlightedMessageText(
                      text: preview,
                      query: query,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 7),
              Icon(
                Icons.chevron_right_rounded,
                color:
                colorScheme.onSurfaceVariant,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedMessageText
    extends StatelessWidget {
  final String text;
  final String query;

  _HighlightedMessageText({
    required this.text,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int matchIndex =
    lowerText.indexOf(lowerQuery);

    TextStyle normalStyle =
        theme.textTheme.bodySmall?.copyWith(
          color:
          colorScheme.onSurfaceVariant,
          fontSize: 12,
          height: 1.3,
        ) ??
            TextStyle();

    if (matchIndex < 0 ||
        lowerQuery.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: normalStyle,
      );
    }

    String before =
    text.substring(0, matchIndex);

    String match = text.substring(
      matchIndex,
      matchIndex + query.length,
    );

    String after = text.substring(
      matchIndex + query.length,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: before,
            style: normalStyle,
          ),
          TextSpan(
            text: match,
            style: normalStyle.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
              backgroundColor:
              colorScheme.primary.withValues(
                alpha: 0.12,
              ),
            ),
          ),
          TextSpan(
            text: after,
            style: normalStyle,
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SearchMessageState
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color iconColor;

  _SearchMessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          30,
          50,
          30,
          100,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor.withValues(
                  alpha: 0.11,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 34,
              ),
            ),
            SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium
                  ?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
              theme.textTheme.bodyMedium?.copyWith(
                color:
                colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}