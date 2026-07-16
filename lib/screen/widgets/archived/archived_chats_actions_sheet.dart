import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';

class ArchivedChatActionsSheet
    extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onUnarchive;
  final VoidCallback onMuteToggle;
  final VoidCallback onDelete;

  ArchivedChatActionsSheet({
    super.key,
    required this.chat,
    required this.onUnarchive,
    required this.onMuteToggle,
    required this.onDelete,
  });

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

    return Padding(
      padding: EdgeInsets.fromLTRB(
        10,
        10,
        10,
        10,
      ),
      child: Material(
        color: cardColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(
            color: borderColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            10,
            10,
            10,
            12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant
                      .withValues(
                    alpha: 0.25,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  10,
                  15,
                  10,
                  13,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary
                            .withValues(
                          alpha: 0.12,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.archive_rounded,
                        color: colorScheme.primary,
                        size: 23,
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: theme
                                .textTheme.titleMedium
                                ?.copyWith(
                              color:
                              colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Archived conversation',
                            style: theme
                                .textTheme.bodySmall
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: borderColor,
              ),

              SizedBox(height: 7),

              _ArchivedActionTile(
                icon: Icons.unarchive_rounded,
                title: 'Unarchive',
                subtitle:
                'Return this conversation to chats',
                iconColor: colorScheme.primary,
                iconBackground:
                colorScheme.primary.withValues(
                  alpha: 0.11,
                ),
                onTap: onUnarchive,
              ),

              _ArchivedActionTile(
                icon: chat.isMuted
                    ? Icons
                    .notifications_active_rounded
                    : Icons
                    .notifications_off_rounded,
                title: chat.isMuted
                    ? 'Unmute notifications'
                    : 'Mute notifications',
                subtitle: chat.isMuted
                    ? 'Receive new message alerts'
                    : 'Stop new message alerts',
                iconColor: colorScheme.primary,
                iconBackground:
                colorScheme.primary.withValues(
                  alpha: 0.11,
                ),
                onTap: onMuteToggle,
              ),

              _ArchivedActionTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete chat',
                subtitle:
                'Remove this conversation',
                iconColor: colorScheme.error,
                iconBackground:
                colorScheme.error.withValues(
                  alpha: 0.10,
                ),
                titleColor: colorScheme.error,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchivedActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;
  final Color? titleColor;
  final VoidCallback onTap;

  _ArchivedActionTile({
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
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(
                        color: titleColor ??
                            colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant
                    .withValues(
                  alpha: 0.65,
                ),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}