import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';

class ArchivedChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeUnarchive;

  ArchivedChatTile({
    super.key,
    required this.chat,
    required this.onTap,
    required this.onLongPress,
    required this.onSwipeUnarchive,
  });

  String _getInitials(String name) {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      return '?';
    }

    List<String> parts = cleanName
        .split(' ')
        .where(
          (String value) {
        return value.trim().isNotEmpty;
      },
    )
        .toList();

    if (parts.length == 1) {
      return parts.first
          .substring(0, 1)
          .toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
        '${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Dismissible(
      key: ValueKey<String>(
        'archived-${chat.id}',
      ),
      direction: DismissDirection.endToStart,
      dismissThresholds: {
        DismissDirection.endToStart: 0.35,
      },
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 5,
        ),
        padding: EdgeInsets.only(
          right: 24,
        ),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.unarchive_rounded,
              color: colorScheme.onPrimary,
              size: 24,
            ),
            SizedBox(height: 3),
            Text(
              'Unarchive',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (
          DismissDirection direction,
          ) {
        onSwipeUnarchive();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 5,
        ),
        child: Material(
          color: cardColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: borderColor,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                13,
                12,
                13,
                12,
              ),
              child: Row(
                children: [
                  _ArchivedChatAvatar(
                    imageUrl: chat.image,
                    initials: _getInitials(
                      chat.name,
                    ),
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
                                TextOverflow.ellipsis,
                                style: theme
                                    .textTheme.titleSmall
                                    ?.copyWith(
                                  color:
                                  colorScheme.onSurface,
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(width: 8),

                            Text(
                              chat.time,
                              style: theme
                                  .textTheme.bodySmall
                                  ?.copyWith(
                                color: colorScheme
                                    .onSurfaceVariant,
                                fontSize: 11,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5),

                        Row(
                          children: [
                            if (chat.isMuted) ...[
                              Icon(
                                Icons
                                    .volume_off_rounded,
                                size: 15,
                                color: colorScheme
                                    .onSurfaceVariant,
                              ),
                              SizedBox(width: 5),
                            ],

                            Expanded(
                              child: Text(
                                chat.isTyping
                                    ? 'Typing...'
                                    : chat.message,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: theme
                                    .textTheme.bodyMedium
                                    ?.copyWith(
                                  color: chat.isTyping
                                      ? colorScheme.primary
                                      : colorScheme
                                      .onSurfaceVariant,
                                  fontSize: 13,
                                  fontWeight:
                                  chat.isTyping
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontStyle:
                                  chat.isTyping
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                            ),

                            if (chat.hasUnread) ...[
                              SizedBox(width: 8),

                              Container(
                                constraints: BoxConstraints(
                                  minWidth: 22,
                                  minHeight: 22,
                                ),
                                alignment: Alignment.center,
                                padding:
                                EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: chat.isMuted
                                      ? colorScheme
                                      .onSurfaceVariant
                                      .withValues(
                                    alpha: 0.65,
                                  )
                                      : colorScheme.primary,
                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Text(
                                  chat.unread > 99
                                      ? '99+'
                                      : '${chat.unread}',
                                  style: TextStyle(
                                    color: chat.isMuted
                                        ? colorScheme.surface
                                        : colorScheme
                                        .onPrimary,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchivedChatAvatar extends StatelessWidget {
  final String imageUrl;
  final String initials;

  _ArchivedChatAvatar({
    required this.imageUrl,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 54,
      height: 54,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: 0.12,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: 0.18,
          ),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: imageUrl.trim().isEmpty
            ? _buildFallback(context)
            : Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
              ) {
            return _buildFallback(context);
          },
        ),
      ),
    );
  }

  Widget _buildFallback(
      BuildContext context,
      ) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      color: colorScheme.primary.withValues(
        alpha: 0.14,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}