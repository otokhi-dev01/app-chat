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
      dismissThresholds: const {
        DismissDirection.endToStart: 0.35,
      },
      background: Container(
        padding: const EdgeInsets.only(right: 24),
        alignment: Alignment.centerRight,
        color: colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Unarchive',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.unarchive_rounded,
              color: colorScheme.onPrimary,
              size: 22,
            ),
          ],
        ),
      ),
      onDismissed: (DismissDirection direction) {
        onSwipeUnarchive();
      },
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.resolveWith(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.black.withValues(alpha: 0.025);
                  }
                  return Colors.transparent;
                },
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          backgroundImage: chat.image.trim().isNotEmpty
                              ? NetworkImage(chat.image)
                              : null,
                          child: chat.image.trim().isEmpty
                              ? Text(
                                  _getInitials(chat.name),
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : null,
                        ),
                        if (chat.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
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
                    const SizedBox(width: 14),
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
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                chat.time,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: chat.unread > 0
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: chat.unread > 0
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (chat.isMuted) ...[
                                Icon(
                                  Icons.volume_off_rounded,
                                  size: 15,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Expanded(
                                child: Text(
                                  chat.isTyping ? 'Typing...' : chat.message,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: chat.isTyping
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                    height: 1.25,
                                    fontWeight: chat.isTyping
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontStyle: chat.isTyping
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ),
                              if (chat.hasUnread) ...[
                                const SizedBox(width: 8),
                                Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chat.isMuted
                                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.65)
                                        : colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    chat.unread > 99 ? '99+' : '${chat.unread}',
                                    style: TextStyle(
                                      color: colorScheme.onPrimary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
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
          Divider(
            height: 1,
            thickness: 1,
            indent: 82,
            endIndent: 14,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ],
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