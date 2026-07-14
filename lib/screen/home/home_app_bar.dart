import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/chat_controller.dart';
import 'home_app_bar_actions.dart';
import 'home_category_filter.dart';
import 'home_search_bar_preview.dart';

class HomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedIndex;
  final List<String> titles;
  final ChatController controller;

  HomeAppBar({
    super.key,
    required this.selectedIndex,
    required this.titles,
    required this.controller,
  });

  double get bottomHeight {
    return selectedIndex == 0 ? 74 : 0;
  }

  String get currentTitle {
    if (selectedIndex < 0 ||
        selectedIndex >= titles.length) {
      return '';
    }

    return titles[selectedIndex];
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      kToolbarHeight + bottomHeight,
    );
  }

  void _handleChatMenu(
      BuildContext context,
      String value,
      ) {
    switch (value) {
      case 'mark_all_read':
        _showMessage(
          context,
          'All chats marked as read',
        );
        break;

      case 'archived_chats':
        _showMessage(
          context,
          'Open archived chats',
        );
        break;

      case 'chat_settings':
        _showMessage(
          context,
          'Open chat settings',
        );
        break;
    }
  }

  void _showMessage(
      BuildContext context,
      String message,
      ) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.primary,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  SystemUiOverlayStyle _overlayStyle(
      ThemeData theme,
      bool isDark,
      ) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor:
        theme.scaffoldBackgroundColor,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(alpha: 0.92)
        : Colors.white.withValues(alpha: 0.96);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFE7E9ED);

    Color actionBackground = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      titleSpacing: 16,
      systemOverlayStyle: _overlayStyle(
        theme,
        isDark,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      actionsIconTheme: IconThemeData(
        color: colorScheme.onSurface,
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
                ),
              ),
            ),
          ),
        ),
      ),
      title: AnimatedSwitcher(
        duration: Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (
            Widget child,
            Animation<double> animation,
            ) {
          Animation<Offset> position =
          Tween<Offset>(
            begin: Offset(0.08, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: position,
              child: child,
            ),
          );
        },
        child: Text(
          currentTitle,
          key: ValueKey<int>(selectedIndex),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      actions: [
        HomeAppBarActions(
          selectedIndex: selectedIndex,
          controller: controller,
          backgroundColor: actionBackground,
          iconColor: colorScheme.onSurface,
          onChatMenuSelected: (String value) {
            _handleChatMenu(
              context,
              value,
            );
          },
        ),
        SizedBox(width: 10),
      ],
      bottom: selectedIndex == 0
          ? PreferredSize(
        preferredSize: Size.fromHeight(74),
        child: Obx(
              () => AnimatedSwitcher(
            duration: Duration(
              milliseconds: 260,
            ),
            switchInCurve:
            Curves.easeOutCubic,
            switchOutCurve:
            Curves.easeInCubic,
            transitionBuilder: (
                Widget child,
                Animation<double> animation,
                ) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              );
            },
            child: controller.isSearching.value
                ? HomeSearchBarPreview(
              key: ValueKey(
                'search-preview',
              ),
              controller: controller,
            )
                : HomeCategoryFilter(
              key: ValueKey(
                'category-filter',
              ),
              controller: controller,
            ),
          ),
        ),
      )
          : null,
    );
  }
}