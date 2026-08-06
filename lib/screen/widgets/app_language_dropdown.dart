import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';

class AppLanguageDropdown extends StatelessWidget {
  final SettingsController controller;

  const AppLanguageDropdown({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color fieldColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color menuBgColor = isDark ? Color(0xFF24272E) : Colors.white;

    return Obx(
          () {
        return DropdownButtonFormField<AppLanguage>(
          initialValue: controller.selectedLanguage.value,
          isExpanded: true,
          dropdownColor: menuBgColor,
          borderRadius: BorderRadius.circular(16),
          menuMaxHeight: 280,
          isDense: true,
          icon: Icon(
            CupertinoIcons.chevron_down,
            color: colorScheme.onSurfaceVariant,
            size: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.4,
              ),
            ),
          ),
          selectedItemBuilder: (
              BuildContext context,
              ) {
            return AppLanguage.values.map(
                  (AppLanguage language) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: _SelectedLanguage(
                    language: language,
                  ),
                );
              },
            ).toList();
          },
          items: [
            DropdownMenuItem<AppLanguage>(
              value: AppLanguage.english,
              child: _LanguageOption(
                flag: '🇺🇸',
                title: 'English',
                subtitle: 'English',
                isSelected:
                controller.selectedLanguage.value == AppLanguage.english,
              ),
            ),
            DropdownMenuItem<AppLanguage>(
              value: AppLanguage.khmer,
              child: _LanguageOption(
                flag: '🇰🇭',
                title: 'ខ្មែរ',
                subtitle: 'Khmer (Cambodia)',
                isSelected:
                controller.selectedLanguage.value == AppLanguage.khmer,
              ),
            ),
            DropdownMenuItem<AppLanguage>(
              value: AppLanguage.chinese,
              child: _LanguageOption(
                flag: '🇨🇳',
                title: '中文',
                subtitle: 'Chinese',
                isSelected:
                controller.selectedLanguage.value == AppLanguage.chinese,
              ),
            ),
          ],
          onChanged: (
              AppLanguage? language,
              ) {
            if (language == null) {
              return;
            }

            FocusManager.instance.primaryFocus?.unfocus();

            controller.changeLanguage(
              language,
            );
          },
        );
      },
    );
  }
}

class _SelectedLanguage extends StatelessWidget {
  final AppLanguage language;

  const _SelectedLanguage({
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _flag,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          _shortLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String get _flag {
    switch (language) {
      case AppLanguage.english:
        return '🇺🇸';

      case AppLanguage.khmer:
        return '🇰🇭';

      case AppLanguage.chinese:
        return '🇨🇳';
    }
  }

  String get _shortLabel {
    switch (language) {
      case AppLanguage.english:
        return 'EN';

      case AppLanguage.khmer:
        return 'ខ្មែរ';

      case AppLanguage.chinese:
        return '中文';
    }
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String title;
  final String subtitle;
  final bool isSelected;

  const _LanguageOption({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: [
        Text(
          flag,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Icon(
            CupertinoIcons.checkmark,
            color: colorScheme.primary,
            size: 16,
          ),
      ],
    );
  }
}