import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';

class DisplaySettingsSection extends StatelessWidget {
  final SettingsController controller;

  DisplaySettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: Text(
            'display'.tr,
            style: theme
                .textTheme.titleSmall
                ?.copyWith(
              color: colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Obx(
                () {
              ThemeMode selectedMode =
                  controller.themeMode.value;

              return Row(
                children: [
                  Expanded(
                    child: _ThemeOption(
                      title:
                      'system_default'.tr,
                      icon: Icons
                          .brightness_auto_rounded,
                      selected:
                      selectedMode ==
                          ThemeMode.system,
                      onTap: () {
                        controller.changeTheme(
                          ThemeMode.system,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _ThemeOption(
                      title: 'light'.tr,
                      icon:
                      Icons.light_mode_outlined,
                      selected:
                      selectedMode ==
                          ThemeMode.light,
                      onTap: () {
                        controller.changeTheme(
                          ThemeMode.light,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _ThemeOption(
                      title: 'dark'.tr,
                      icon:
                      Icons.dark_mode_outlined,
                      selected:
                      selectedMode ==
                          ThemeMode.dark,
                      onTap: () {
                        controller.changeTheme(
                          ThemeMode.dark,
                        );
                      },
                    ),
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

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  _ThemeOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.12,
    )
        : colorScheme
        .surfaceContainerHighest
        .withValues(
      alpha: isDark ? 0.55 : 0.45,
    );

    Color optionBorderColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.75,
    )
        : colorScheme.outlineVariant
        .withValues(
      alpha: isDark ? 0.18 : 0.25,
    );

    Color foregroundColor = selected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    Color pressedColor = isDark
        ? Colors.white.withValues(
      alpha: 0.05,
    )
        : Colors.black.withValues(
      alpha: 0.035,
    );

    return Material(
      color: backgroundColor,
      borderRadius:
      BorderRadius.circular(15),
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius:
        BorderRadius.circular(15),
        splashFactory:
        InkRipple.splashFactory,
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor:
        WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return pressedColor;
            }

            return Colors.transparent;
          },
        ),
        child: Container(
          height: 82,
          padding: EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(15),
            border: Border.all(
              color: optionBorderColor,
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: Center(
                  child: Icon(
                    icon,
                    size: 26,
                    color: foregroundColor,
                  ),
                ),
              ),
              SizedBox(height: 7),
              SizedBox(
                height: 18,
                child: Center(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    textAlign:
                    TextAlign.center,
                    strutStyle: StrutStyle(
                      fontSize: 12,
                      height: 1.2,
                      forceStrutHeight: true,
                    ),
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}