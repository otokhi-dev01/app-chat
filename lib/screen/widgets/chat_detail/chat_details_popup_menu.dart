import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';

class ChatDetailPopupMenu extends StatelessWidget {
  final ChatModel chat;
  final ValueChanged<String>? onSelected;
  final Color buttonBackground;

  ChatDetailPopupMenu({
    super.key,
    required this.chat,
    required this.onSelected,
    required this.buttonBackground,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color menuColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFE7E9ED);

    return PopupMenuButton<String>(
      tooltip: 'More',
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,

      // Positive X moves the popup toward the right.
      offset: Offset(36, 5),

      constraints: BoxConstraints(
        minWidth: 220,
        maxWidth: 245,
      ),
      color: menuColor,
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      shadowColor: Colors.black.withValues(
        alpha: isDark ? 0.30 : 0.12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: borderColor,
        ),
      ),
      onSelected: onSelected,
      icon: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.more_vert_rounded,
          color: colorScheme.onSurface,
          size: 22,
        ),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'view_profile',
            child: _ChatPopupMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'View profile',
            ),
          ),
          PopupMenuItem<String>(
            value: 'search',
            child: _ChatPopupMenuItem(
              icon: Icons.search_rounded,
              title: 'Search messages',
            ),
          ),
          PopupMenuItem<String>(
            value: 'mute',
            child: _ChatPopupMenuItem(
              icon: chat.isMuted
                  ? Icons.notifications_outlined
                  : Icons.notifications_off_outlined,
              title: chat.isMuted
                  ? 'Unmute notifications'
                  : 'Mute notifications',
            ),
          ),
          PopupMenuDivider(
            height: 10,
          ),
          PopupMenuItem<String>(
            value: 'clear',
            child: _ChatPopupMenuItem(
              icon: Icons.delete_sweep_outlined,
              title: 'Clear conversation',
              isDanger: true,
            ),
          ),
        ];
      },
    );
  }
}

class _ChatPopupMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDanger;

  _ChatPopupMenuItem({
    required this.icon,
    required this.title,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color itemColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: itemColor.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: itemColor,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDanger
                  ? colorScheme.error
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}