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

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFE7E9ED);

    Color buttonBackground = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    return PopupMenuButton<String>(
      tooltip: 'More',
      padding: EdgeInsets.zero,
      color: menuColor,
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      shadowColor: Colors.black.withValues(
        alpha: isDark ? 0.30 : 0.12,
      ),
      position: PopupMenuPosition.under,
      offset: Offset(-8, 5),
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: borderColor,
        ),
      ),
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
            value: 'mark_all_read',
            child: HomeChatMenuItem(
              icon: Icons.mark_chat_read_outlined,
              title: 'Mark all as read',
              iconColor: colorScheme.primary,
            ),
          ),

          PopupMenuItem<String>(
            value: 'archived_chats',
            child: HomeChatMenuItem(
              icon: Icons.archive_outlined,
              title: 'Archived chats',
              iconColor: colorScheme.primary,
            ),
          ),

          PopupMenuItem<String>(
            value: 'chat_settings',
            child: HomeChatMenuItem(
              icon: Icons.settings_outlined,
              title: 'Chat settings',
              iconColor: colorScheme.primary,
            ),
          ),
        ];
      },
    );
  }
}

class HomeChatMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color? textColor;

  HomeChatMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    this.textColor,
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
            color: iconColor.withValues(
              alpha: 0.11,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor ??
                  colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}