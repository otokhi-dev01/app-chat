import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/settings/settings_search_controller.dart';

class SettingsSearchScreen extends GetView<SettingsSearchController> {
  const SettingsSearchScreen({
    super.key,
  });

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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color pageColor = theme.scaffoldBackgroundColor;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.65,
    )
        : Colors.white.withValues(
      alpha: 0.70,
    );

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color inputColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(
        theme,
        isDark,
      ),
      child: Scaffold(
        backgroundColor: pageColor,
        appBar: AppBar(
          toolbarHeight: 72,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
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
          title: Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              10,
              12,
              10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: inputColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: borderColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.15 : 0.04,
                          ),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(
                          () {
                        bool hasText =
                            controller.searchQuery.value.isNotEmpty;

                        return TextField(
                          controller: controller.searchController,
                          focusNode: controller.searchFocusNode,
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onChanged: controller.updateSearch,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'search_settings'.tr,
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.black.withValues(alpha: 0.4),
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                            suffixIcon: hasText
                                ? CupertinoButton(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(32, 32),
                              onPressed: controller.clearSearch,
                              child: Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.black.withValues(alpha: 0.4),
                                size: 18,
                              ),
                            )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: controller.closeSearch,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: Text(
                    'cancel'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Obx(
                () {
              List<SettingsSearchItem> filteredItems =
                  controller.filteredItems;

              String query = controller.searchQuery.value;

              if (filteredItems.isEmpty) {
                return _SettingsSearchEmpty(
                  query: query,
                );
              }

              Map<String, List<SettingsSearchItem>> groupedItems =
                  controller.groupedItems;

              List<String> sections = groupedItems.keys.toList();

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  14,
                  18,
                  14,
                  30,
                ),
                itemCount: sections.length,
                itemBuilder: (
                    BuildContext context,
                    int sectionIndex,
                    ) {
                  String section = sections[sectionIndex];

                  List<SettingsSearchItem> items =
                      groupedItems[section] ?? <SettingsSearchItem>[];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            6,
                            0,
                            6,
                            8,
                          ),
                          child: Text(
                            section.tr,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(
                              22,
                            ),
                            border: Border.all(
                              color: borderColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.15 : 0.04,
                                ),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: List<Widget>.generate(
                              items.length,
                                  (int index) {
                                SettingsSearchItem item = items[index];

                                bool showDivider = index < items.length - 1;

                                return Column(
                                  children: [
                                    _SettingsSearchTile(
                                      item: item,
                                      query: query,
                                      onTap: () {
                                        controller.selectSetting(
                                          item,
                                        );
                                      },
                                    ),
                                    if (showDivider)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 68,
                                        ),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: borderColor,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SettingsSearchTile extends StatelessWidget {
  final SettingsSearchItem item;
  final String query;
  final VoidCallback onTap;

  const _SettingsSearchTile({
    required this.item,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            12,
            12,
            12,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HighlightedText(
                      text: item.title,
                      query: query,
                      normalStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      highlightedStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(
                CupertinoIcons.chevron_right,
                color: colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.55,
                ),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? normalStyle;
  final TextStyle? highlightedStyle;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.normalStyle,
    required this.highlightedStyle,
  });

  @override
  Widget build(BuildContext context) {
    String cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      return Text(
        text,
        style: normalStyle,
      );
    }

    String lowerText = text.toLowerCase();

    int startIndex = lowerText.indexOf(cleanQuery);

    if (startIndex < 0) {
      return Text(
        text,
        style: normalStyle,
      );
    }

    int endIndex = startIndex + cleanQuery.length;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text.substring(
              0,
              startIndex,
            ),
            style: normalStyle,
          ),
          TextSpan(
            text: text.substring(
              startIndex,
              endIndex,
            ),
            style: highlightedStyle,
          ),
          TextSpan(
            text: text.substring(
              endIndex,
            ),
            style: normalStyle,
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SettingsSearchEmpty extends StatelessWidget {
  final String query;

  const _SettingsSearchEmpty({
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: 0.11,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: colorScheme.primary,
                size: 32,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'no_results_found'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              query.trim().isEmpty
                  ? 'search_settings_hint'.tr
                  : 'no_results_for'.trParams({'query': query}),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}