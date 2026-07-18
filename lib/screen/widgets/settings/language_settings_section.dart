import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';

class LanguageSettingsSection
    extends StatelessWidget {
  final SettingsController controller;

  LanguageSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color dividerColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    AppLanguage selectedLanguage =
        controller.currentLanguage;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 6,
            right: 6,
            bottom: 8,
          ),
          child: Text(
            'language'.tr,
            style: theme
                .textTheme.titleSmall
                ?.copyWith(
              color:
              theme.colorScheme.primary,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: Column(
            children: [
              _LanguageSectionItem(
                title: 'english'.tr,
                subtitle: 'English',
                iconText: 'EN',
                selected:
                selectedLanguage ==
                    AppLanguage.english,
                onTap: () {
                  controller.changeLanguage(
                    AppLanguage.english,
                  );
                },
              ),
              _LanguageDivider(
                color: dividerColor,
              ),
              _LanguageSectionItem(
                title: 'khmer'.tr,
                subtitle: 'ភាសាខ្មែរ',
                iconText: 'ខ',
                selected:
                selectedLanguage ==
                    AppLanguage.khmer,
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

class _LanguageSectionItem
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconText;
  final bool selected;
  final VoidCallback onTap;

  _LanguageSectionItem({
    required this.title,
    required this.subtitle,
    required this.iconText,
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
        onTap: selected
            ? null
            : onTap,
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
                  text: iconText,
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

class _LanguageIcon
    extends StatelessWidget {
  final String text;
  final bool selected;

  _LanguageIcon({
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary
            : colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(13),
        border: Border.all(
          color: selected
              ? colorScheme.primary
              : colorScheme.outlineVariant
              .withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected
              ? colorScheme.onPrimary
              : colorScheme
              .onSurfaceVariant,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LanguageInformation
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;

  _LanguageInformation({
    required this.title,
    required this.subtitle,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge
              ?.copyWith(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurface,
            fontWeight: selected
                ? FontWeight.w700
                : FontWeight.w600,
          ),
        ),
        SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall
              ?.copyWith(
            color: colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LanguageIndicator
    extends StatelessWidget {
  final bool selected;

  _LanguageIndicator({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.5,
          color: selected
              ? colorScheme.primary
              : colorScheme.outline,
        ),
      ),
      child: selected
          ? Icon(
        Icons.check_rounded,
        size: 16,
        color:
        colorScheme.onPrimary,
      )
          : SizedBox.shrink(),
    );
  }
}

class _LanguageDivider
    extends StatelessWidget {
  final Color color;

  _LanguageDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 71,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }
}