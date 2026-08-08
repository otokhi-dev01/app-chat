import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import '../section/settings_divider.dart';
import '../section/settings_icon.dart';

/// UPDATED: Dedicated Display Settings Page without vibration/shake effects
class DisplaySettingsScreen extends StatelessWidget {
  final SettingsController controller;

  const DisplaySettingsScreen({
    super.key,
    required this.controller,
  });

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
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
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color actionBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    SystemUiOverlayStyle overlayStyle = _overlayStyle(theme, isDark);
    final double topSpace = MediaQuery.of(context).padding.top + 68;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
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
          systemOverlayStyle: overlayStyle,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: double.infinity,
                height: double.infinity,
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
            padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: actionBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.0),
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
          title: Text(
            'display'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(14, topSpace, 14, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
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
                child: Obx(() {
                  ThemeMode selectedMode = controller.themeMode.value;
                  bool isAutomatic = selectedMode == ThemeMode.system;

                  bool showLightSelected = selectedMode == ThemeMode.light ||
                      (isAutomatic && !isDark);

                  bool showDarkSelected = selectedMode == ThemeMode.dark ||
                      (isAutomatic && isDark);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _IosAppearanceCard(
                                title: 'light'.tr,
                                isDarkMockup: false,
                                selected: showLightSelected,
                                // REMOVED: Removed HapticFeedback vibration
                                onTap: () {
                                  controller.changeTheme(ThemeMode.light);
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _IosAppearanceCard(
                                title: 'dark'.tr,
                                isDarkMockup: true,
                                selected: showDarkSelected,
                                // REMOVED: Removed HapticFeedback vibration
                                onTap: () {
                                  controller.changeTheme(ThemeMode.dark);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SettingsDivider(color: borderColor),
                      _IosAutomaticRow(
                        isAutomatic: isAutomatic,
                        // REMOVED: Removed HapticFeedback vibration
                        onChanged: (bool value) {
                          if (value) {
                            controller.changeTheme(ThemeMode.system);
                            return;
                          }
                          controller.changeTheme(
                            isDark ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IosAppearanceCard extends StatelessWidget {
  final String title;
  final bool isDarkMockup;
  final bool selected;
  final VoidCallback onTap;

  const _IosAppearanceCard({
    required this.title,
    required this.isDarkMockup,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color mockupBackground =
    isDarkMockup ? const Color(0xFF0E1621) : const Color(0xFFF5F6F8);

    Color myBubbleColor =
    isDarkMockup ? const Color(0xFF24A1DE) : const Color(0xFFC4AA29);

    Color otherBubbleColor =
    isDarkMockup ? const Color(0xFF17212B) : Colors.white;

    Color placeholderColor = isDarkMockup
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.10);

    return _TapArea(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: mockupBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withValues(
                  alpha: 0.30,
                ),
                width: selected ? 2.2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 24,
                        height: 5,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 5,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 54,
                      height: 14,
                      decoration: BoxDecoration(
                        color: otherBubbleColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                          bottomLeft: Radius.circular(2),
                        ),
                        boxShadow: isDarkMockup
                            ? null
                            : [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.04,
                            ),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 44,
                      height: 14,
                      decoration: BoxDecoration(
                        color: myBubbleColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? colorScheme.primary : Colors.transparent,
              border: Border.all(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            child: selected
                ? Icon(
              CupertinoIcons.checkmark,
              color: colorScheme.onPrimary,
              size: 12,
            )
                : null,
          ),
        ],
      ),
    );
  }
}

class _IosAutomaticRow extends StatelessWidget {
  final bool isAutomatic;
  final ValueChanged<bool> onChanged;

  const _IosAutomaticRow({
    required this.isAutomatic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return _TapArea(
      onTap: () {
        onChanged(!isAutomatic);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            SettingsIcon(
              icon: CupertinoIcons.sun_max,
              active: isAutomatic,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'system_default'.tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isAutomatic
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight:
                      isAutomatic ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'follow_device_appearance'.tr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CupertinoSwitch(
              value: isAutomatic,
              activeTrackColor: colorScheme.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _TapArea extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _TapArea({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}