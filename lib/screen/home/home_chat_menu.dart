import 'package:flutter/material.dart';

class HomeChatMenu extends StatelessWidget {
  final ValueChanged<String> onSelected;

  HomeChatMenu({
    super.key,
    required this.onSelected,
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

    Color buttonColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFE7E9ED);

    return PopupMenuButton<String>(
      tooltip: 'More',
      padding: EdgeInsets.zero,
      color: menuColor,
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      position: PopupMenuPosition.under,
      offset: Offset(14, 6),
      constraints: BoxConstraints(
        minWidth: 220,
        maxWidth: 245,
      ),
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
          color: buttonColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.more_vert_rounded,
          color: colorScheme.onSurface,
          size: 22,
        ),
      ),
      itemBuilder: (
          BuildContext context,
          ) {
        return [
          PopupMenuItem<String>(
            value: 'mark_all_read',
            child: _HomeChatMenuItem(
              icon: Icons.mark_chat_read_outlined,
              title: 'Mark all as read',
            ),
          ),

          PopupMenuItem<String>(
            value: 'archived_chats',
            child: _HomeChatMenuItem(
              icon: Icons.archive_outlined,
              title: 'Archived chats',
            ),
          ),
        ];
      },
    );
  }
}

class _HomeChatMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  _HomeChatMenuItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(
              alpha: 0.11,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}