import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';
import 'home_chat_actions_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Swipe-to-archive + long-press-actions wrapper
// ─────────────────────────────────────────────────────────────────────────────

class HomeChatTileWrapper extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onPin;
  final VoidCallback onMuteToggle;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  HomeChatTileWrapper({
    super.key,
    required this.chat,
    required this.onTap,
    required this.onArchive,
    required this.onPin,
    required this.onMuteToggle,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey<String>('swipe-archive-${chat.id}'),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {
        DismissDirection.endToStart: 0.35,
      },
      confirmDismiss: (DismissDirection direction) async {
        onArchive();
        return false; // Actual removal handled by reactive list rebuild
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: colorScheme.tertiary.withValues(alpha: 0.85),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Archive',
              style: TextStyle(
                color: colorScheme.onTertiary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.archive_rounded,
              color: colorScheme.onTertiary,
              size: 22,
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          HomeChatTile(
            chat: chat,
            onTap: onTap,
            onLongPress: () => HomeChatActionsSheet.show(
              context: context,
              chat: chat,
              onPin: onPin,
              onMuteToggle: onMuteToggle,
              onArchive: onArchive,
              onMarkRead: onMarkRead,
              onDelete: onDelete,
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

// ─────────────────────────────────────────────────────────────────────────────
// Chat tile
// ─────────────────────────────────────────────────────────────────────────────

class HomeChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  HomeChatTile({
    super.key,
    required this.chat,
    required this.onTap,
    this.onLongPress,
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

    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime startOfMessageDay =
        DateTime(dateTime.year, dateTime.month, dateTime.day);
    int difference = startOfToday.difference(startOfMessageDay).inDays;

    if (difference == 1) return 'Yesterday';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  IconData get fallbackIcon {
    if (chat.type == 'group') return Icons.groups_rounded;
    return Icons.person_rounded;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool hasImage = chat.image.trim().isNotEmpty;

    Color pressedColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.025);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
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
                    backgroundImage:
                        hasImage ? NetworkImage(chat.image) : null,
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
                              Icons.push_pin_rounded,
                              color: colorScheme.onSurfaceVariant,
                              size: 15,
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
                              Icons.volume_off_rounded,
                              color: colorScheme.onSurfaceVariant,
                              size: 15,
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
                              fontWeight: chat.unread > 0
                                  ? FontWeight.w500
                                  : FontWeight.w400,
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
                      fontWeight: chat.unread > 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 7),
                  if (chat.unread > 0)
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 21,
                        minHeight: 21,
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6),
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
                          color: chat.isMuted
                              ? theme.scaffoldBackgroundColor
                              : colorScheme.onPrimary,
                          fontSize: 9,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 21, height: 21),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
