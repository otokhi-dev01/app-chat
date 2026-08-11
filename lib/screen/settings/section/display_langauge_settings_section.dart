import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import '../display/display_settings_screen.dart';
import '../language/language_settings_screen.dart';
import 'settings_icon.dart';
import 'settings_section_title.dart';

class DisplayLanguageSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const DisplayLanguageSettingsSection({
    super.key,
    required this.controller,
  });

  Widget _settingsRow({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    required Widget subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            SettingsIcon(
              icon: icon,
              active: true,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  subtitle,
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              CupertinoIcons.chevron_right,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color cardColor =
    isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(
          title: 'display_language'.tr,
          icon: CupertinoIcons.gear,
        ),
        const SizedBox(height: 8),

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
            child: Column(
              children: [
                _settingsRow(
                  context: context,
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: CupertinoIcons.brightness,
                  title: 'display'.tr,
                  onTap: () {
                    Get.to(
                          () => DisplaySettingsScreen(
                        controller: controller,
                      ),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 280),
                    );
                  },
                  subtitle: Obx(() {
                    final mode = controller.themeMode.value;
                    String label;

                    if (mode == ThemeMode.system) {
                      label = 'system_default'.tr;
                    } else if (mode == ThemeMode.dark) {
                      label = 'dark'.tr;
                    } else {
                      label = 'light'.tr;
                    }

                    return Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    );
                  }),
                ),

                Divider(
                  height: 1,
                  indent: 67,
                  endIndent: 14,
                  color: borderColor,
                ),

                _settingsRow(
                  context: context,
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: CupertinoIcons.globe,
                  title: 'language'.tr,
                  onTap: () {
                    Get.to(
                          () => LanguageSettingsScreen(
                        controller: controller,
                      ),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 280),
                    );
                  },
                  subtitle: Obx(() {
                    final lang = controller.currentLanguage;
                    String languageName;

                    if (lang == AppLanguage.english) {
                      languageName = 'English';
                    } else if (lang == AppLanguage.khmer) {
                      languageName = 'ភាសាខ្មែរ';
                    } else if (lang == AppLanguage.chinese) {
                      languageName = '中文';
                    } else {
                      languageName = 'English';
                    }

                    return Text(
                      languageName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}