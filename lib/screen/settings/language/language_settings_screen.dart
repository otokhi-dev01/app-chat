import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import '../section/settings_divider.dart';

/// UPDATED: Language Settings Screen using flag emojis (🇺🇸, 🇰🇭, 🇨🇳) instead of image assets
class LanguageSettingsScreen extends StatelessWidget {
  final SettingsController controller;

  const LanguageSettingsScreen({
    super.key,
    required this.controller,
  });

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color actionBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    SystemUiOverlayStyle overlayStyle = _overlayStyle(theme, isDark);
    final double topSpace = MediaQuery.of(context).padding.top + 68;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        // UPDATED: Glassmorphism blurred AppBar with 40x40 circular elevated back button
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          forceMaterialTransparency: true,
          titleSpacing: 0,
          leadingWidth: 58,
          systemOverlayStyle: overlayStyle,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: appBarColor,
                  border: Border(
                    bottom: BorderSide(
                      color: dividerColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: actionBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: dividerColor, width: 1.0),
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
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                },
                child: Icon(
                  CupertinoIcons.chevron_left,
                  size: 20,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          title: Text(
            'language'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(14, topSpace, 14, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UPDATED: Unit UI card container holding English, Khmer, and Chinese language items
              Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: dividerColor),
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
                child: Obx(() {
                  AppLanguage selectedLanguage = controller.currentLanguage;

                  return Column(
                    children: [
                      // REPLACED: English option using flag emoji '🇺🇸' instead of image asset
                      _LanguageSectionItem(
                        flag: '🇺🇸',
                        title: 'english'.tr,
                        subtitle: 'English',
                        selected: selectedLanguage == AppLanguage.english,
                        onTap: () {
                          controller.changeLanguage(AppLanguage.english);
                        },
                      ),
                      SettingsDivider(color: dividerColor),

                      // REPLACED: Khmer option using flag emoji '🇰🇭' instead of image asset
                      _LanguageSectionItem(
                        flag: '🇰🇭',
                        title: 'khmer'.tr,
                        subtitle: 'ភាសាខ្មែរ',
                        selected: selectedLanguage == AppLanguage.khmer,
                        onTap: () {
                          controller.changeLanguage(AppLanguage.khmer);
                        },
                      ),
                      SettingsDivider(color: dividerColor),

                      // REPLACED: Chinese option using flag emoji '🇨🇳' instead of image asset
                      _LanguageSectionItem(
                        flag: '🇨🇳',
                        title: 'chinese'.tr,
                        subtitle: '中文',
                        selected: selectedLanguage == AppLanguage.chinese,
                        onTap: () {
                          controller.changeLanguage(AppLanguage.chinese);
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSectionItem extends StatelessWidget {
  final String flag;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageSectionItem({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark = theme.brightness == Brightness.dark;

    Color pressedColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.035);

    Color backgroundColor = selected
        ? theme.colorScheme.primary.withValues(alpha: 0.07)
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
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                // REPLACED: Renders flag emoji icon box instead of image asset
                _LanguageIcon(
                  flag: flag,
                  selected: selected,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: _LanguageInformation(
                    title: title,
                    subtitle: subtitle,
                    selected: selected,
                  ),
                ),
                const SizedBox(width: 12),
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
  final String flag;
  final bool selected;

  const _LanguageIcon({
    required this.flag,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(alpha: 0.13)
        : colorScheme.primary.withValues(alpha: 0.11);

    Color borderColor = selected
        ? colorScheme.primary
        : colorScheme.outlineVariant.withValues(alpha: 0.20);

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      // REPLACED: Replaced Image.asset with flag emoji text (fontSize 22)
      child: Text(
        flag,
        style: const TextStyle(
          fontSize: 22,
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
          : const SizedBox.shrink(),
    );
  }
}