import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import '../display/display_settings_screen.dart';
import 'settings_icon.dart';
import 'settings_section_title.dart';

/// UPDATED: Displays section title and a clean settings navigation tile to open DisplaySettingsScreen without vibration
class DisplaySettingsSection extends StatelessWidget {
  final SettingsController controller;

  const DisplaySettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ADDED: Kept the section title above the navigation tile
        SettingsSectionTitle(
          title: 'display'.tr,
          icon: CupertinoIcons.brightness,
        ),
        const SizedBox(height: 8),

        // UPDATED: Navigation button card tile leading to DisplaySettingsScreen
        Container(
          clipBehavior: Clip.antiAlias,
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              // REMOVED: Removed HapticFeedback vibration to prevent screen shake
              onTap: () {
                Get.to(
                      () => DisplaySettingsScreen(controller: controller),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 280),
                );
              },
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const SettingsIcon(
                      icon: CupertinoIcons.brightness,
                      active: true,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'display'.tr,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // UPDATED: Displays active theme status dynamically
                          Obx(() {
                            String themeStatusLabel;
                            final mode = controller.themeMode.value;
                            if (mode == ThemeMode.system) {
                              themeStatusLabel = 'system_default'.tr;
                            } else if (mode == ThemeMode.dark) {
                              themeStatusLabel = 'dark'.tr;
                            } else {
                              themeStatusLabel = 'light'.tr;
                            }

                            return Text(
                              themeStatusLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
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
          ),
        ),
      ],
    );
  }
}