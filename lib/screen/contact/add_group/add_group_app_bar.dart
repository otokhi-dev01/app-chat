import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddGroupAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool canCreate;
  final bool isCreating;
  final VoidCallback onCreate;

  AddGroupAppBar({
    super.key,
    required this.canCreate,
    required this.isCreating,
    required this.onCreate,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(64);
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
      alpha: 0.95,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor:
      colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      titleSpacing: 0,
      leadingWidth: 58,
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
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.fromLTRB(
          9,
          13,
          7,
          13,
        ),
        child: Material(
          color: actionBackground,
          shape: CircleBorder(),
          child: Tooltip(
            message: 'back'.tr,
            child: InkWell(
              onTap: () {
                FocusManager
                    .instance.primaryFocus
                    ?.unfocus();

                Get.back();
              },
              customBorder: CircleBorder(),
              splashColor: Colors.transparent,
              highlightColor:
              Colors.transparent,
              child: SizedBox(
                width: 38,
                height: 38,
                child: Icon(
                  Icons
                      .arrow_back_ios_new_rounded,
                  color:
                  colorScheme.onSurface,
                  size: 17,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'new_group'.tr,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme.titleMedium
                ?.copyWith(
              color:
              colorScheme.onSurface,
              fontSize: 17,
              fontWeight:
              FontWeight.w700,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'new_group_subtitle'.tr,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme.bodySmall
                ?.copyWith(
              color: colorScheme
                  .onSurfaceVariant,
              fontSize: 11,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: 10,
          ),
          child: Center(
            child: FilledButton(
              onPressed:
              canCreate && !isCreating
                  ? onCreate
                  : null,
              style:
              FilledButton.styleFrom(
                minimumSize: Size(
                  72,
                  38,
                ),
                padding:
                EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),
              ),
              child: isCreating
                  ? SizedBox(
                width: 17,
                height: 17,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme
                      .onPrimary,
                ),
              )
                  : Text(
                'create'.tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}