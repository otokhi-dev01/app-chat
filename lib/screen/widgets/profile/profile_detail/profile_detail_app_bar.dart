import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onQrCodeTap;

  ProfileAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.onQrCodeTap,
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
        statusBarBrightness:
        Brightness.dark,
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
      statusBarBrightness:
      Brightness.light,
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
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.94,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
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
        title,
        maxLines: 1,
        overflow:
        TextOverflow.ellipsis,
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
          child: Center(
            child: Material(
              color: actionBackground,
              shape: CircleBorder(),
              child: Tooltip(
                message: 'qr_code'.tr,
                child: InkWell(
                  onTap: onQrCodeTap,
                  customBorder:
                  CircleBorder(),
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
                      Icons.qr_code_rounded,
                      color: colorScheme
                          .onSurface,
                      size: 21,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}