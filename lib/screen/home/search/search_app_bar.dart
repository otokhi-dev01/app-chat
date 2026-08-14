import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/search/search_controller.dart';

class SearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ChatSearchController controller;

  const SearchAppBar({
    super.key,
    required this.controller,
  });

  @override
  Size get preferredSize {
    return const Size.fromHeight(68);
  }

  void _closeSearch(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Get.back();
  }

  void _clearSearch() {
    controller.clearSearch();
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

    final Color headerColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    final Color actionBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color searchBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return AppBar(
      toolbarHeight: 68,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      titleSpacing: 0,
      leadingWidth: 58,
      systemOverlayStyle: _overlayStyle(theme, isDark),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: headerColor,
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
        padding: const EdgeInsets.fromLTRB(12, 14, 6, 14),
        child: Tooltip(
          message: 'back'.tr,
          child: Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: actionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: 1,
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
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 40),
              onPressed: () => _closeSearch(context),
              child: Icon(
                CupertinoIcons.chevron_left,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: searchBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
              width: 1,
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
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(
                CupertinoIcons.search,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.searchTextController,
                  autofocus: true,
                  onChanged: controller.updateSearch,
                  onSubmitted: (String value) {
                    controller.search(value);
                  },
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: colorScheme.primary,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'search_chats'.tr,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.4),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 11,
                    ),
                  ),
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
              Obx(() {
                if (controller.searchQuery.value.isEmpty) {
                  return const SizedBox(width: 12);
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(32, 32),
                    onPressed: _clearSearch,
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      size: 18,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}