import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/chat_message_model.dart';

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

    if (value == searchQuery) {
      return;
    }

    setState(() {
      searchQuery = value;
    });
  }

  void _clearSearch() {
    HapticFeedback.lightImpact();
    searchController.clear();
  }

  List<ChatMessageModel> get filteredMessages {
    if (searchQuery.isEmpty) {
      return [];
    }

    return widget.messages.where((ChatMessageModel message) {
      String searchableText = _getSearchableText(message).toLowerCase();
      return searchableText.contains(searchQuery);
    }).toList();
  }

  String _getSearchableText(ChatMessageModel message) {
    List<String> values = [
      message.text,
      _getMessageTypeLabel(message),
      _getFileName(message),
    ];

    if (message.latitude != null && message.longitude != null) {
      values.add('${message.latitude}, ${message.longitude}');
    }

    return values.join(' ');
  }

  String _getMessageTypeLabel(ChatMessageModel message) {
    switch (message.type) {
      case ChatMessageType.text:
        return 'text message';
      case ChatMessageType.image:
        return 'photo image picture';
      case ChatMessageType.voice:
        return 'voice audio message recording';
      case ChatMessageType.file:
        return 'file document pdf attachment';
      case ChatMessageType.location:
        return 'location map address gps';
      case ChatMessageType.video:
        return 'video movie clip';
      case ChatMessageType.contact:
        return 'contact card phone number';
      case ChatMessageType.sticker:
        return 'sticker emoji';
      case ChatMessageType.gif:
        return 'gif animation';
      case ChatMessageType.call:
        return 'call log phone video';
      case ChatMessageType.system:
        return 'system notification';
    }
  }

  String _getMessagePreview(ChatMessageModel message) {
    String text = message.text.trim();

    switch (message.type) {
      case ChatMessageType.text:
        return text.isEmpty ? 'Text message' : text;
      case ChatMessageType.image:
        return text.isEmpty ? 'Photo' : text;
      case ChatMessageType.voice:
        return text.isEmpty ? 'Voice message' : text;
      case ChatMessageType.file:
        if (text.isNotEmpty) return text;
        String fileName = _getFileName(message);
        return fileName.isEmpty ? 'File' : fileName;
      case ChatMessageType.location:
        if (text.isNotEmpty) return text;
        if (message.latitude != null && message.longitude != null) {
          return '${message.latitude!.toStringAsFixed(4)}, ${message.longitude!.toStringAsFixed(4)}';
        }
        return 'Shared location';
      case ChatMessageType.video:
        return text.isEmpty ? 'Video' : text;
      case ChatMessageType.contact:
        return text.isEmpty ? 'Contact' : text;
      case ChatMessageType.sticker:
        return 'Sticker';
      case ChatMessageType.gif:
        return 'GIF';
      case ChatMessageType.call:
        return text.isEmpty ? 'Call' : text;
      case ChatMessageType.system:
        return text.isEmpty ? 'System message' : text;
    }
  }

  String _getFileName(ChatMessageModel message) {
    String? mediaPath = message.mediaPath;

    if (mediaPath == null || mediaPath.trim().isEmpty) {
      return '';
    }

    String normalizedPath = mediaPath.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  IconData _getMessageIcon(ChatMessageType type) {
    switch (type) {
      case ChatMessageType.text:
        return CupertinoIcons.chat_bubble;
      case ChatMessageType.image:
        return CupertinoIcons.photo;
      case ChatMessageType.voice:
        return CupertinoIcons.mic;
      case ChatMessageType.file:
        return CupertinoIcons.doc;
      case ChatMessageType.location:
        return CupertinoIcons.location;
      case ChatMessageType.video:
        return CupertinoIcons.videocam;
      case ChatMessageType.contact:
        return CupertinoIcons.person_crop_circle;
      case ChatMessageType.sticker:
        return CupertinoIcons.smiley;
      case ChatMessageType.gif:
        return CupertinoIcons.play_rectangle;
      case ChatMessageType.call:
        return CupertinoIcons.phone;
      case ChatMessageType.system:
        return CupertinoIcons.info_circle;
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

    String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  String _formatDate(DateTime dateTime) {
    DateTime now = DateTime.now();

    bool isToday = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      return _formatTime(dateTime);
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    bool isYesterday = yesterday.year == dateTime.year &&
        yesterday.month == dateTime.month &&
        yesterday.day == dateTime.day;

    if (isYesterday) {
      return 'Yesterday';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
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

    Color searchBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    SystemUiOverlayStyle overlayStyle = _getOverlayStyle(
      theme: theme,
      isDark: isDark,
    );

    List<ChatMessageModel> results = filteredMessages;

    return Scaffold(
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
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Tooltip(
            message: 'Back',
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
        ),
        title: Text(
          'Search messages',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                color: searchBackground,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: borderColor,
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
              child: TextField(
                controller: searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                keyboardAppearance:
                isDark ? Brightness.dark : Brightness.light,
                cursorColor: colorScheme.primary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search in ${widget.chatName}',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.4),
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
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.4),
                      size: 18,
                    ),
                  )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: _buildBody(
          context: context,
          results: results,
          cardColor: cardColor,
          borderColor: borderColor,
          isDark: isDark,
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required List<ChatMessageModel> results,
    required Color cardColor,
    required Color borderColor,
    required bool isDark,
  }) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    if (searchQuery.isEmpty) {
      return _SearchMessageState(
        icon: CupertinoIcons.search,
        title: 'Search messages',
        message:
        'Search text, photos, voice messages, files, or locations in ${widget.chatName}.',
        iconColor: colorScheme.primary,
      );
    }

    if (results.isEmpty) {
      return _SearchMessageState(
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
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
            itemBuilder: (BuildContext context, int index) {
              ChatMessageModel message = results[index];

              return _MessageSearchResultTile(
                key: ValueKey(message.id),
                message: message,
                query: searchQuery,
                preview: _getMessagePreview(message),
                dateText: _formatDate(message.sentAt),
                icon: _getMessageIcon(message.type),
                cardColor: cardColor,
                borderColor: borderColor,
                isDark: isDark,
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

class _MessageSearchResultTile extends StatelessWidget {
  final ChatMessageModel message;
  final String query;
  final String preview;
  final String dateText;
  final IconData icon;
  final Color cardColor;
  final Color borderColor;
  final bool isDark;
  final VoidCallback onTap;

  const _MessageSearchResultTile({
    super.key,
    required this.message,
    required this.query,
    required this.preview,
    required this.dateText,
    required this.icon,
    required this.cardColor,
    required this.borderColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              children: [
                // Icon Box Container (42x42 with 14px radius)
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 20,
                  ),
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
                              message.isMe ? 'You' : 'Received',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      _HighlightedMessageText(
                        text: preview,
                        query: query,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  CupertinoIcons.chevron_right,
                  color: colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.55,
                  ),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HighlightedMessageText extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedMessageText({
    required this.text,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int matchIndex = lowerText.indexOf(lowerQuery);

    TextStyle normalStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontSize: 12,
      height: 1.3,
    ) ??
        const TextStyle();

    if (matchIndex < 0 || lowerQuery.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: normalStyle,
      );
    }

    String before = text.substring(0, matchIndex);
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
              backgroundColor: colorScheme.primary.withValues(
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

class _SearchMessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color iconColor;

  const _SearchMessageState({
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
        padding: const EdgeInsets.fromLTRB(28, 40, 28, 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
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
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}