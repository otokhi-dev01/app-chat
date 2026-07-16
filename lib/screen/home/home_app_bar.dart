import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import 'home_app_bar_actions.dart';
import 'home_category_filter.dart';

class HomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedIndex;
  final List<String> titles;
  final ChatController controller;
  final VoidCallback onOpenSettings;

  HomeAppBar({
    super.key,
    required this.selectedIndex,
    required this.titles,
    required this.controller,
    required this.onOpenSettings,
  });

  double get bottomHeight {
    return selectedIndex == 0 ? 74 : 0;
  }

  String _getTranslatedTitle(int index) {
    switch (index) {
      case 0:
        return 'chats'.tr;

      case 1:
        return 'contacts'.tr;

      case 2:
        return 'settings'.tr;

      case 3:
        return 'profile'.tr;

      default:
        if (index >= 0 && index < titles.length) {
          return titles[index];
        }

        return '';
    }
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      kToolbarHeight + bottomHeight,
    );
  }

  Future<void> _handleChatMenu(
      BuildContext context,
      String value,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    switch (value) {
      case 'mark_all_read':
        controller.markAllAsRead();

        _showMessage(
          context,
          'all_chats_marked_as_read'.tr,
        );
        break;

      case 'archived_chats':
        await controller.openArchivedChatsScreen();
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
          content: Text(
            message,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.primary,
          margin: EdgeInsets.all(14),
          duration: Duration(
            milliseconds: 1800,
          ),
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
        systemNavigationBarIconBrightness:
        Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
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
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.94,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFE7E9ED);

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      centerTitle: selectedIndex != 0,
      titleSpacing: 20,
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
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      title: AnimatedSwitcher(
        duration: Duration(
          milliseconds: 300,
        ),
        switchInCurve: Curves.easeOutQuart,
        switchOutCurve: Curves.easeInQuart,
        transitionBuilder: (
            Widget child,
            Animation<double> animation,
            ) {
          Animation<Offset> slideTransition =
          Tween<Offset>(
            begin: Offset(0.15, 0),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideTransition,
              child: child,
            ),
          );
        },
        child: Text(
          _getTranslatedTitle(selectedIndex),
          key: ValueKey<int>(
            selectedIndex,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
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
        child: HomeCategoryFilter(
          controller: controller,
        ),
      )
          : null,
    );
  }
}