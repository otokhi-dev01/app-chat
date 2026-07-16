import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';

class DisplaySettingsSection extends StatelessWidget {
  final SettingsController controller;

  const DisplaySettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            'display'.tr,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Flat card — no shadow, just a thin border like the rest of the UI.
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1B1D22)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Obx(() {
            final ThemeMode selectedMode =
                controller.themeMode.value;

            return Row(
              children: [
                Expanded(
                  child: _ThemeOption(
                    title: 'system_default'.tr,
                    icon: Icons.brightness_auto_rounded,
                    selected:
                    selectedMode == ThemeMode.system,
                    onTap: () {
                      controller.changeTheme(
                        ThemeMode.system,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _ThemeOption(
                    title: 'light'.tr,
                    icon: Icons.light_mode_outlined,
                    selected:
                    selectedMode == ThemeMode.light,
                    onTap: () {
                      controller.changeTheme(
                        ThemeMode.light,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _ThemeOption(
                    title: 'dark'.tr,
                    icon: Icons.dark_mode_outlined,
                    selected:
                    selectedMode == ThemeMode.dark,
                    onTap: () {
                      controller.changeTheme(
                        ThemeMode.dark,
                      );
                    },
                  ),
                ),
              ],
            );
          }),
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

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary =
        Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: primary.withValues(alpha: 0.12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 82,
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.12)
              : Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: selected
                  ? primary
                  : Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected
                    ? primary
                    : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
                fontSize: 12,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}