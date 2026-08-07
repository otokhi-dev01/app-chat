import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/chat_model.dart';

class ChatDetailPopupMenu extends StatelessWidget {
  final ChatModel chat;
  final ValueChanged<String>? onSelected;
  final Color buttonBackground;

  const ChatDetailPopupMenu({
    super.key,
    required this.chat,
    required this.onSelected,
    required this.buttonBackground,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color menuColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return PopupMenuButton<String>(
      tooltip: 'More',
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      offset: const Offset(36, 5),
      constraints: const BoxConstraints(
        minWidth: 220,
        maxWidth: 245,
      ),
      color: menuColor,
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black.withValues(
        alpha: isDark ? 0.30 : 0.10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: borderColor,
        ),
      ),
      onSelected: (String value) {
        HapticFeedback.lightImpact();
        onSelected?.call(value);
      },
      icon: Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: buttonBackground,
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
        alignment: Alignment.center,
        child: Icon(
          CupertinoIcons.ellipsis_vertical,
          color: colorScheme.onSurface,
          size: 19,
        ),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'search',
            child: const _ChatPopupMenuItem(
              icon: CupertinoIcons.search,
              title: 'Search messages',
            ),
          ),
          PopupMenuItem<String>(
            value: 'mute',
            child: _ChatPopupMenuItem(
              icon: chat.isMuted
                  ? CupertinoIcons.bell
                  : CupertinoIcons.bell_slash,
              title: chat.isMuted
                  ? 'Unmute notifications'
                  : 'Mute notifications',
            ),
          ),
          const PopupMenuDivider(
            height: 10,
          ),
          PopupMenuItem<String>(
            value: 'clear',
            child: const _ChatPopupMenuItem(
              icon: CupertinoIcons.trash,
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

  const _ChatPopupMenuItem({
    required this.icon,
    required this.title,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color itemColor = isDanger ? colorScheme.error : colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: itemColor.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: itemColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDanger ? colorScheme.error : colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}