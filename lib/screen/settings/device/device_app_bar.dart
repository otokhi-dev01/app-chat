import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/device/device_controller.dart';

class DevicesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final DeviceController controller;

  DevicesAppBar({
    super.key,
    required this.controller,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(64);
  }

  SystemUiOverlayStyle _getOverlayStyle({
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
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor:
      colorScheme.onSurface,
      surfaceTintColor:
      Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      titleSpacing: 0,
      leadingWidth: 58,
      systemOverlayStyle:
      _getOverlayStyle(
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
          9,
          13,
          7,
          13,
        ),
        child: Material(
          color: actionBackground,
          shape: CircleBorder(),
          child: Tooltip(
            message: 'Back',
            child: InkWell(
              onTap: () {
                FocusManager
                    .instance.primaryFocus
                    ?.unfocus();

                Get.back();
              },
              customBorder:
              CircleBorder(),
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
      title: Obx(
            () {
          int sessionCount =
              controller.sessions.length;

          int otherSessionCount =
              controller.otherSessionCount;

          String subtitle;

          if (controller.isLoading.value &&
              controller.sessions.isEmpty) {
            subtitle =
            'Loading devices...';
          } else if (sessionCount == 0) {
            subtitle =
            'No active devices';
          } else if (otherSessionCount == 0) {
            subtitle =
            'Only this device';
          } else if (otherSessionCount == 1) {
            subtitle =
            '1 other active session';
          } else {
            subtitle =
            '$otherSessionCount other active sessions';
          }

          return Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'devices'.tr,
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
                subtitle,
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
          );
        },
      ),
      actions: [
        Obx(
              () {
            bool isLoading =
                controller.isLoading.value;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                7,
                13,
                9,
                13,
              ),
              child: Material(
                color: actionBackground,
                shape: CircleBorder(),
                child: Tooltip(
                  message: 'Refresh',
                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () {
                      controller
                          .refreshSessions();
                    },
                    customBorder:
                    CircleBorder(),
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Center(
                        child: isLoading
                            ? SizedBox(
                          width: 18,
                          height: 18,
                          child:
                          CircularProgressIndicator(
                            strokeWidth:
                            2.2,
                            color:
                            colorScheme
                                .primary,
                          ),
                        )
                            : Icon(
                          Icons
                              .refresh_rounded,
                          color:
                          colorScheme
                              .primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}