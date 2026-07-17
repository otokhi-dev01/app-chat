import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';

class LanguageSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const LanguageSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            right: 6,
            bottom: 8,
          ),
          child: Text(
            'language'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1D22) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: Obx(() {
            final selectedLanguage = controller.language.value;

            return Column(
              children: [
                _LanguageSectionItem(
                  title: 'english'.tr,
                  subtitle: 'English',
                  iconText: 'EN',
                  selected: selectedLanguage == AppLanguage.english,
                  onTap: () {
                    controller.changeLanguage(
                      AppLanguage.english,
                    );
                  },
                ),
                _LanguageDivider(color: dividerColor),
                _LanguageSectionItem(
                  title: 'khmer'.tr,
                  subtitle: 'ភាសាខ្មែរ',
                  iconText: 'ខ',
                  selected: selectedLanguage == AppLanguage.khmer,
                  onTap: () {
                    controller.changeLanguage(
                      AppLanguage.khmer,
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _LanguageSectionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconText;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageSectionItem({
    required this.title,
    required this.subtitle,
    required this.iconText,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    return _BouncyLanguageTile(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        color: selected ? primary.withValues(alpha: 0.08) : Colors.transparent,
        child: Row(
          children: [
            // Avatar Code-Box Spring Animation
            AnimatedScale(
              scale: selected ? 1.06 : 1.0,
              duration: const Duration(milliseconds: 240),
              curve: const Cubic(0.2, 1.4, 0.3, 1.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? primary : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: selected
                      ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  iconText,
                  style: TextStyle(
                    color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: selected ? primary : colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Liquid-switch checkmark pop
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: const Cubic(0.2, 1.4, 0.3, 1.0),
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: selected
                  ? Container(
                key: const ValueKey('selected'),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: colorScheme.onPrimary,
                ),
              )
                  : Container(
                key: const ValueKey('unselected'),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1.5,
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageDivider extends StatelessWidget {
  final Color color;

  const _LanguageDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 71),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }
}

// 4. Custom stateful language press animation to keep the screen's main page stateless
class _BouncyLanguageTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncyLanguageTile({
    required this.child,
    required this.onTap,
  });

  @override
  State<_BouncyLanguageTile> createState() => _BouncyLanguageTileState();
}

class _BouncyLanguageTileState extends State<_BouncyLanguageTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}