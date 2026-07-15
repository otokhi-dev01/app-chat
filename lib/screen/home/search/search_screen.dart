import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../controllers/chat_controller.dart';
import '../home_chat_list.dart';

class SearchScreen extends StatelessWidget {
  final ChatController controller;

  SearchScreen({
    super.key,
    required this.controller,
  });

  void _closeSearch(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
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

    Color headerColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.95,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color searchBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

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

    return PopScope(
      onPopInvokedWithResult: (
          bool didPop,
          Object? result,
          ) {
        if (!didPop) {
          return;
        }

        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:
        theme.scaffoldBackgroundColor,
        appBar: AppBar(
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
          systemOverlayStyle: _overlayStyle(
            theme,
            isDark,
          ),
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
            padding: EdgeInsets.fromLTRB(
              8,
              12,
              6,
              12,
            ),
            child: Material(
              color: actionBackground,
              shape: CircleBorder(),
              child: Tooltip(
                message: 'Back',
                child: InkWell(
                  onTap: () {
                    _closeSearch(context);
                  },
                  customBorder: CircleBorder(),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                      size: 18,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: searchBackground,
                borderRadius:
                BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 13),

                  Icon(
                    Icons.search_rounded,
                    size: 21,
                    color: colorScheme.primary,
                  ),

                  SizedBox(width: 9),

                  Expanded(
                    child: TextField(
                      controller:
                      controller.searchTextController,
                      autofocus: true,
                      onChanged:
                      controller.updateSearch,
                      textInputAction:
                      TextInputAction.search,
                      keyboardType:
                      TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor:
                      colorScheme.primary,
                      style: theme
                          .textTheme.bodyLarge
                          ?.copyWith(
                        color:
                        colorScheme.onSurface,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search chats',
                        hintStyle: theme
                            .textTheme.bodyLarge
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        enabledBorder:
                        InputBorder.none,
                        focusedBorder:
                        InputBorder.none,
                        isDense: true,
                        contentPadding:
                        EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                      ),
                      onTapOutside: (
                          PointerDownEvent event,
                          ) {
                        FocusManager
                            .instance.primaryFocus
                            ?.unfocus();
                      },
                    ),
                  ),

                  ValueListenableBuilder<
                      TextEditingValue>(
                    valueListenable:
                    controller.searchTextController,
                    builder: (
                        BuildContext context,
                        TextEditingValue value,
                        Widget? child,
                        ) {
                      if (value.text.isEmpty) {
                        return SizedBox(
                          width: 8,
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.only(
                          right: 4,
                        ),
                        child: Material(
                          color: colorScheme
                              .onSurfaceVariant
                              .withValues(
                            alpha: 0.10,
                          ),
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Clear search',
                            child: InkWell(
                              onTap: _clearSearch,
                              customBorder:
                              CircleBorder(),
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // Uses your existing HomeChatList and ChatTile.
        body: HomeChatList(
          controller: controller,
          isSearchMode: true,
          enableHomeScrollBehavior: false,
          enableRefresh: false,
          topPadding: 6,
          bottomPadding: 30,
          emptyTopPadding: 120,
          emptyBottomPadding: 40,
        ),
      ),
    );
  }
}