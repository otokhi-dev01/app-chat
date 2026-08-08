import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import '../language/language_settings_screen.dart';
import 'settings_icon.dart';
import 'settings_section_title.dart';

/// UPDATED: Displays section title and a clean navigation button tile to open LanguageSettingsScreen without vibration/shake
class LanguageSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const LanguageSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // UPDATED: Theme awareness for dynamic light and dark mode adaptation
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    // UPDATED: Standardized unit UI card background and border colors
    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ADDED: Kept the section title above the navigation card
        SettingsSectionTitle(
          title: 'language'.tr,
          icon: CupertinoIcons.globe,
        ),
        const SizedBox(height: 8),

        // UPDATED: Navigation button tile card leading to LanguageSettingsScreen
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
              // REMOVED: Removed HapticFeedback to prevent screen/device vibration
              onTap: () {
                Get.to(
                      () => LanguageSettingsScreen(controller: controller),
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
                    // UPDATED: Settings icon widget with Cupertino globe icon
                    const SettingsIcon(
                      icon: CupertinoIcons.globe,
                      active: true,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'language'.tr,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // UPDATED: Dynamically displays active language name (English, ភាសាខ្មែរ, or 中文)
                          Obx(() {
                            String activeLanguageName;
                            final lang = controller.currentLanguage;
                            if (lang == AppLanguage.english) {
                              activeLanguageName = 'English';
                            } else if (lang == AppLanguage.khmer) {
                              activeLanguageName = 'ភាសាខ្មែរ';
                            } else if (lang == AppLanguage.chinese) {
                              activeLanguageName = '中文';
                            } else {
                              activeLanguageName = 'English';
                            }

                            return Text(
                              activeLanguageName,
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
                    // UPDATED: Trailing Cupertino chevron right icon
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