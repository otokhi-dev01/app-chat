import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AboutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AboutAppBar({
    super.key,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(60);
  }

  SystemUiOverlayStyle _getOverlayStyle({
    required ThemeData theme,
    required bool isDark,
  }) {
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

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.65,
    )
        : Colors.white.withValues(
      alpha: 0.70,
    );

    Color actionBackground = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return AppBar(
      toolbarHeight: 60,
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
      systemOverlayStyle: _getOverlayStyle(
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
          12,
          10,
          6,
          10,
        ),
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
                width: 1.0,
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
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size(40, 40),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              },
              child: Icon(
                CupertinoIcons.chevron_left,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'about_app'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'version_information'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}