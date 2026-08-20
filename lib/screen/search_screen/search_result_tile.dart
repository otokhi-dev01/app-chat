import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';

/// ADDED: Chat search result list item tile
class SearchResultTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.chat,
    required this.onTap,
  });

  String _formatTime(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final bool isToday = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      final String hour = dateTime.hour.toString().padLeft(2, '0');
      final String minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool hasImage = chat.image.trim().isNotEmpty;

    final IconData fallbackIcon = chat.type == 'group'
        ? CupertinoIcons.person_3_fill
        : CupertinoIcons.person_fill;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Avatar (28px radius)
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

              const SizedBox(width: 12),

              // Title & Message Preview
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
                              fontSize: 15,
                              fontWeight: chat.unread > 0
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (chat.isPinned)
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              CupertinoIcons.pin_fill,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      chat.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Timestamp & Unread Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(chat.dateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
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
                        chat.unread > 99 ? '99+' : '${chat.unread}',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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