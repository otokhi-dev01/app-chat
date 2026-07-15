import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final ValueChanged<String>? onMenuSelected;

  ProfileAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.onMenuSelected,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(60);
  }

  SystemUiOverlayStyle _overlayStyle({
    required ThemeData theme,
    required bool isDark,
  }) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor:
        theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22)
        .withValues(alpha: 0.94)
        : Colors.white
        .withValues(alpha: 0.98);

    Color actionBackground = isDark
        ? Colors.white
        .withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white
        .withValues(alpha: 0.08)
        : Color(0xFFE7E9ED);

    return AppBar(
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor:
      colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      leadingWidth: 54,
      titleSpacing: 0,
      systemOverlayStyle: _overlayStyle(
        theme: theme,
        isDark: isDark,
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: appBarColor,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.fromLTRB(
          8,
          12,
          5,
          12,
        ),
        child: Material(
          color: actionBackground,
          shape: CircleBorder(),
          child: Tooltip(
            message: 'Back',
            child: InkWell(
              onTap: onBack,
              customBorder: CircleBorder(),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  Icons
                      .arrow_back_ios_new_rounded,
                  size: 16,
                  color:
                  colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme
            .textTheme.titleMedium
            ?.copyWith(
          color: colorScheme.onSurface,
          fontSize: 17,
          height: 1.1,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: 8,
          ),
          child: PopupMenuButton<String>(
            tooltip: 'More',
            position: PopupMenuPosition.under,
            offset: Offset(0, 6),
            color: isDark
                ? Color(0xFF1B1D22)
                : Colors.white,
            surfaceTintColor:
            Colors.transparent,
            elevation: 10,
            shadowColor: Colors.black
                .withValues(
              alpha: isDark ? 0.30 : 0.12,
            ),
            constraints: BoxConstraints(
              minWidth: 205,
              maxWidth: 230,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(18),
              side: BorderSide(
                color: borderColor,
              ),
            ),
            onSelected: (
                String value,
                ) {
              onMenuSelected?.call(value);
            },
            icon: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: actionBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color:
                colorScheme.onSurface,
                size: 21,
              ),
            ),
            itemBuilder: (
                BuildContext context,
                ) {
              return [
                PopupMenuItem<String>(
                  value: 'share',
                  child: _ProfileMenuItem(
                    icon: Icons.share_outlined,
                    title: 'Share profile',
                  ),
                ),
                PopupMenuDivider(
                  height: 10,
                ),
                PopupMenuItem<String>(
                  value: 'block',
                  child: _ProfileMenuItem(
                    icon:
                    Icons.block_rounded,
                    title: 'Block user',
                    isDanger: true,
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDanger;

  _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

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
            color: itemColor
                .withValues(alpha: 0.11),
            borderRadius:
            BorderRadius.circular(11),
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
            style: theme
                .textTheme.bodyMedium
                ?.copyWith(
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