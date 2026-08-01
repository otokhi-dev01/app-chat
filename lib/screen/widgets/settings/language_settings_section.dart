import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import 'settings_divider.dart';
import 'settings_section_title.dart';

class LanguageSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const LanguageSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color dividerColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    AppLanguage selectedLanguage = controller.currentLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(
          title: 'language'.tr,
          icon: CupertinoIcons.globe,
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: dividerColor,
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
          child: Column(
            children: [
              _LanguageSectionItem(
                title: 'english'.tr,
                subtitle: 'English',
                imagePath: 'assets/images/languages/english.png',
                fallbackText: 'EN',
                selected: selectedLanguage == AppLanguage.english,
                onTap: () {
                  controller.changeLanguage(
                    AppLanguage.english,
                  );
                },
              ),
              SettingsDivider(
                color: dividerColor,
              ),
              _LanguageSectionItem(
                title: 'khmer'.tr,
                subtitle: 'ភាសាខ្មែរ',
                imagePath: 'assets/images/languages/khmer.png',
                fallbackText: 'ខ',
                selected: selectedLanguage == AppLanguage.khmer,
                onTap: () {
                  controller.changeLanguage(
                    AppLanguage.khmer,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageSectionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String fallbackText;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageSectionItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.fallbackText,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color pressedColor = isDark
        ? Colors.white.withValues(
      alpha: 0.05,
    )
        : Colors.black.withValues(
      alpha: 0.035,
    );

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.07,
    )
        : Colors.transparent;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: selected ? null : onTap,
        splashColor: Colors.transparent,
        highlightColor: pressedColor,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: SizedBox(
          height: 70,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Row(
              children: [
                _LanguageIcon(
                  imagePath: imagePath,
                  fallbackText: fallbackText,
                  selected: selected,
                ),
                SizedBox(width: 13),
                Expanded(
                  child: _LanguageInformation(
                    title: title,
                    subtitle: subtitle,
                    selected: selected,
                  ),
                ),
                SizedBox(width: 12),
                _LanguageIndicator(
                  selected: selected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageIcon extends StatelessWidget {
  final String imagePath;
  final String fallbackText;
  final bool selected;

  const _LanguageIcon({
    required this.imagePath,
    required this.fallbackText,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.13,
    )
        : colorScheme.primary.withValues(
      alpha: 0.11,
    );

    Color borderColor = selected
        ? colorScheme.primary
        : colorScheme.outlineVariant.withValues(
      alpha: 0.20,
    );

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
              ) {
            return Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.primary.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                fallbackText,
                style: TextStyle(
                  color: selected
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LanguageInformation extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;

  const _LanguageInformation({
    required this.title,
    required this.subtitle,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: selected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LanguageIndicator extends StatelessWidget {
  final bool selected;

  const _LanguageIndicator({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? colorScheme.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.5,
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      ),
      child: selected
          ? Icon(
        CupertinoIcons.checkmark,
        size: 13,
        color: colorScheme.onPrimary,
      )
          : SizedBox.shrink(),
    );
  }
}