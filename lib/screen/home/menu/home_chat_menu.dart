import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeChatMenu extends StatelessWidget {
  final ValueChanged<String> onSelected;
  final Color? backgroundColor;
  final Color? iconColor;

  const HomeChatMenu({
    super.key,
    required this.onSelected,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color menuColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    // Follows the active surface background color
    Color buttonColor = backgroundColor ??
        (isDark ? const Color(0xFF1B1D22) : Colors.white);

    // Follows the active border color
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color icnColor = iconColor ?? colorScheme.onSurface;

    return PopupMenuButton<String>(
      tooltip: 'More',
      padding: EdgeInsets.zero,
      color: menuColor,
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      position: PopupMenuPosition.under,
      offset: const Offset(14, 6),
      constraints: const BoxConstraints(
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
          width: 1,
        ),
      ),
      onSelected: onSelected,
      icon: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
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
        child: Icon(
          CupertinoIcons.add, // Native iOS 3-dots icon
          color: icnColor,
          size: 20,
        ),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'add_group',
            child: _HomeChatMenuItem(
              icon: CupertinoIcons.person_2,
              title: 'add_group'.tr,
            ),
          ),
          PopupMenuItem<String>(
            value: 'saved_messages',
            child: _HomeChatMenuItem(
              icon: CupertinoIcons.bookmark,
              title: 'saved_messages'.tr,
            ),
          ),
          PopupMenuItem<String>(
            value: 'archived_chats',
            child: _HomeChatMenuItem(
              icon: CupertinoIcons.archivebox,
              title: 'archived_chats'.tr,
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

  const _HomeChatMenuItem({
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
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
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