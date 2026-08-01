import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import 'settings_divider.dart';
import 'settings_icon.dart';
import 'settings_section_title.dart';

class DisplaySettingsSection extends StatelessWidget {
  final SettingsController controller;

  const DisplaySettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme _ = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(
          title: 'display'.tr,
          icon: CupertinoIcons.brightness,
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
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
              ThemeMode selectedMode = controller.themeMode.value;

              bool isAutomatic = selectedMode == ThemeMode.system;

              bool showLightSelected = selectedMode == ThemeMode.light ||
                  (isAutomatic && !isDark);

              bool showDarkSelected =
                  selectedMode == ThemeMode.dark || (isAutomatic && isDark);

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      20,
                      16,
                      16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _IosAppearanceCard(
                            title: 'light'.tr,
                            isDarkMockup: false,
                            selected: showLightSelected,
                            onTap: () {
                              controller.changeTheme(
                                ThemeMode.light,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: _IosAppearanceCard(
                            title: 'dark'.tr,
                            isDarkMockup: true,
                            selected: showDarkSelected,
                            onTap: () {
                              controller.changeTheme(
                                ThemeMode.dark,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SettingsDivider(
                    color: borderColor,
                  ),
                  _IosAutomaticRow(
                    isAutomatic: isAutomatic,
                    onChanged: (bool value) {
                      if (value) {
                        controller.changeTheme(
                          ThemeMode.system,
                        );
                        return;
                      }

                      controller.changeTheme(
                        isDark ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
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
    isDarkMockup ? Color(0xFF0E1621) : Color(0xFFF5F6F8);

    Color myBubbleColor =
    isDarkMockup ? Color(0xFF24A1DE) : Color(0xFFC4AA29);

    Color otherBubbleColor =
    isDarkMockup ? Color(0xFF17212B) : Colors.white;

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
              padding: EdgeInsets.symmetric(
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
                  Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 54,
                      height: 14,
                      decoration: BoxDecoration(
                        color: otherBubbleColor,
                        borderRadius: BorderRadius.only(
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
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 44,
                      height: 14,
                      decoration: BoxDecoration(
                        color: myBubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 6),
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? colorScheme.primary : Colors.transparent,
              border: Border.all(
                color: selected ? colorScheme.primary : colorScheme.outlineVariant,
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
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            SettingsIcon(
              icon: CupertinoIcons.sun_max,
              active: isAutomatic,
            ),
            SizedBox(width: 13),
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
                      fontWeight: isAutomatic ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
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
            SizedBox(width: 10),
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