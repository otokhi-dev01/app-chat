import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddContactAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  AddContactAppBar({
    super.key,
    required this.onBack,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(60);
  }

  SystemUiOverlayStyle _overlayStyle({
    required ThemeData theme,
    required bool isDark,
  }) {
    Brightness iconBrightness = isDark
        ? Brightness.light
        : Brightness.dark;

    Brightness statusBrightness = isDark
        ? Brightness.dark
        : Brightness.light;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      iconBrightness,
      statusBarBrightness:
      statusBrightness,
      systemStatusBarContrastEnforced:
      false,
      systemNavigationBarColor:
      Colors.transparent,
      systemNavigationBarDividerColor:
      Colors.transparent,
      systemNavigationBarIconBrightness:
      iconBrightness,
      systemNavigationBarContrastEnforced:
      false,
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
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.96,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : colorScheme.surfaceContainerHighest
        .withValues(
      alpha: 0.75,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : colorScheme.outlineVariant.withValues(
      alpha: 0.45,
    );

    return AppBar(
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor:
      colorScheme.onSurface,
      surfaceTintColor:
      Colors.transparent,
      shadowColor:
      Colors.transparent,
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
            message: 'back'.tr,
            child: InkWell(
              onTap: onBack,
              customBorder: CircleBorder(),
              splashColor:
              Colors.transparent,
              highlightColor:
              Colors.transparent,
              hoverColor:
              Colors.transparent,
              focusColor:
              Colors.transparent,
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
        'add_contact'.tr,
        maxLines: 1,
        overflow:
        TextOverflow.ellipsis,
        style: theme
            .textTheme.titleMedium
            ?.copyWith(
          color: colorScheme.onSurface,
          fontSize: 17,
          height: 1.1,
          fontWeight:
          FontWeight.w700,
        ),
      ),
    );
  }
}