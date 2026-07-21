import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/chat_model.dart';

class HomeChatActionsSheet extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onPin;
  final VoidCallback onMuteToggle;
  final VoidCallback onArchive;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  HomeChatActionsSheet({
    super.key,
    required this.chat,
    required this.onPin,
    required this.onMuteToggle,
    required this.onArchive,
    required this.onMarkRead,
    required this.onDelete,
  });

  /// Opens the actions sheet and returns after the user dismisses it.
  static Future<void> show({
    required BuildContext context,
    required ChatModel chat,
    required VoidCallback onPin,
    required VoidCallback onMuteToggle,
    required VoidCallback onArchive,
    required VoidCallback onMarkRead,
    required VoidCallback onDelete,
  }) async {
    HapticFeedback.lightImpact();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext sheetContext) {
        return HomeChatActionsSheet(
          chat: chat,
          onPin: () {
            Navigator.of(sheetContext).pop();
            onPin();
          },
          onMuteToggle: () {
            Navigator.of(sheetContext).pop();
            onMuteToggle();
          },
          onArchive: () {
            Navigator.of(sheetContext).pop();
            onArchive();
          },
          onMarkRead: () {
            Navigator.of(sheetContext).pop();
            onMarkRead();
          },
          onDelete: () {
            Navigator.of(sheetContext).pop();
            onDelete();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    bool hasImage = chat.image.trim().isNotEmpty;

    IconData fallbackIcon =
        chat.type == 'group' ? Icons.groups_rounded : Icons.person_rounded;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            // Header — avatar + name
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 13),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    backgroundImage:
                        hasImage ? NetworkImage(chat.image) : null,
                    child: hasImage
                        ? null
                        : Icon(
                            fallbackIcon,
                            color: colorScheme.onSurfaceVariant,
                            size: 22,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          chat.type == 'group' ? 'Group chat' : 'Personal chat',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: borderColor),

            const SizedBox(height: 7),

            // Pin / Unpin
            _ActionTile(
              icon: chat.isPinned
                  ? Icons.push_pin_outlined
                  : Icons.push_pin_rounded,
              title: chat.isPinned ? 'Unpin' : 'Pin',
              subtitle: chat.isPinned
                  ? 'Remove from pinned chats'
                  : 'Keep this chat at the top',
              iconColor: colorScheme.primary,
              iconBackground: colorScheme.primary.withValues(alpha: 0.11),
              onTap: onPin,
            ),

            // Mute / Unmute
            _ActionTile(
              icon: chat.isMuted
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              title: chat.isMuted ? 'Unmute' : 'Mute',
              subtitle: chat.isMuted
                  ? 'Receive new message alerts'
                  : 'Stop new message alerts',
              iconColor: colorScheme.primary,
              iconBackground: colorScheme.primary.withValues(alpha: 0.11),
              onTap: onMuteToggle,
            ),

            // Archive
            _ActionTile(
              icon: Icons.archive_rounded,
              title: 'Archive',
              subtitle: 'Move this chat to archive',
              iconColor: colorScheme.primary,
              iconBackground: colorScheme.primary.withValues(alpha: 0.11),
              onTap: onArchive,
            ),

            // Mark read / unread
            _ActionTile(
              icon: chat.unread > 0
                  ? Icons.mark_chat_read_rounded
                  : Icons.mark_chat_unread_rounded,
              title: chat.unread > 0 ? 'Mark as read' : 'Mark as unread',
              subtitle: chat.unread > 0
                  ? 'Clear unread message count'
                  : 'Show as having unread messages',
              iconColor: colorScheme.primary,
              iconBackground: colorScheme.primary.withValues(alpha: 0.11),
              onTap: onMarkRead,
            ),

            // Delete
            _ActionTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete chat',
              subtitle: 'Remove this conversation',
              iconColor: colorScheme.error,
              iconBackground: colorScheme.error.withValues(alpha: 0.10),
              titleColor: colorScheme.error,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;
  final Color? titleColor;
  final VoidCallback onTap;

  _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBackground,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: titleColor ?? colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
