import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../route/app_route.dart';
import 'folder_filter/home_category_filter.dart';
import 'home_app_bar_actions.dart';
import 'home_app_bar_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final List<String> titles;
  final ChatController controller;
  final VoidCallback onOpenSettings;

  const HomeAppBar({
    super.key,
    required this.selectedIndex,
    required this.titles,
    required this.controller,
    required this.onOpenSettings,
  });

  double get bottomHeight {
    return selectedIndex == 0 ? 56 : 0;
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
      case 'add_group':
        await Get.toNamed(AppRoutes.addGroup);
        break;

      case 'saved_messages':
        await Get.toNamed(AppRoutes.savedMessages);
        break;

      case 'archived_chats':
        await controller.openArchivedChatsScreen();
        break;
    }
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
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final Color actionBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      centerTitle: selectedIndex != 0,
      // UPDATED: Set titleSpacing to 0 on Profile tab so center title is balanced with leading button
      titleSpacing: selectedIndex == 3 ? 0 : 20,
      // ADDED: Width configuration for the leading QR Scan button container
      leadingWidth: selectedIndex == 3 ? 58 : null,
      // ADDED: QR Scan button placed on the LEFT side (leading) when on Profile tab (selectedIndex == 3)
      leading: selectedIndex == 3
          ? Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
        child: HomeAppBarActionButton(
          tooltip: 'scan_qr'.tr,
          icon: CupertinoIcons.qrcode_viewfinder,
          backgroundColor: actionBackground,
          foregroundColor: colorScheme.onSurface,
          onPressed: () {
            Get.toNamed(AppRoutes.qrScanner);
          },
        ),
      )
          : null,
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
        duration: const Duration(
          milliseconds: 300,
        ),
        switchInCurve: Curves.easeOutQuart,
        switchOutCurve: Curves.easeInQuart,
        transitionBuilder: (
            Widget child,
            Animation<double> animation,
            ) {
          Animation<Offset> slideTransition = Tween<Offset>(
            begin: const Offset(0.15, 0),
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
      // UPDATED: Right side actions (contains Edit Profile button when selectedIndex == 3)
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
        const SizedBox(width: 10),
      ],
      bottom: selectedIndex == 0
          ? PreferredSize(
        preferredSize: Size.fromHeight(bottomHeight),
        child: HomeCategoryFilter(
          controller: controller,
        ),
      )
          : null,
    );
  }
}