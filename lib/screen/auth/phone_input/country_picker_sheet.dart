import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/telegram_login_controller.dart';
import 'country_search_empty_state.dart';
import 'country_search_title.dart';

class CountryPickerSheet {
  CountryPickerSheet._();

  /// Opens the country picker modal without vibration, shaking, or layout jitter.
  static Future<void> show({
    required BuildContext context,
    required TelegramLoginController controller,
    List<String>? favoriteIsoCodes,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (BuildContext sheetContext) {
        return _CountryPickerSheetContent(
          controller: controller,
          favoriteIsoCodes:
          favoriteIsoCodes ?? const ['KH', 'US', 'TH', 'SG', 'GB'],
        );
      },
    );
  }
}

class _CountryPickerSheetContent extends StatefulWidget {
  final TelegramLoginController controller;
  final List<String> favoriteIsoCodes;

  const _CountryPickerSheetContent({
    required this.controller,
    required this.favoriteIsoCodes,
  });

  @override
  State<_CountryPickerSheetContent> createState() =>
      __CountryPickerSheetContentState();
}

class __CountryPickerSheetContentState
    extends State<_CountryPickerSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  List<Country> _allCountries = [];

  @override
  void initState() {
    super.initState();
    _allCountries = CountryService().getAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  List<Country> get _filteredCountries {
    final String query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _allCountries;

    return _allCountries.where((Country country) {
      final String name = country.name.toLowerCase();
      final String code = country.phoneCode.toLowerCase();
      final String iso = country.countryCode.toLowerCase();
      return name.contains(query) ||
          code.contains(query) ||
          iso.contains(query);
    }).toList();
  }

  List<Country> get _favoriteCountries {
    return _allCountries.where((Country country) {
      return widget.favoriteIsoCodes
          .contains(country.countryCode.toUpperCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color sheetColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color cardColor = isDark ? const Color(0xFF26282E) : Colors.white;
    Color searchBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final double availableHeight = MediaQuery.of(context).size.height * 0.85;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: availableHeight,
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Drag Handle
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

              const SizedBox(height: 12),

              // Search Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: searchBackground,
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
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          textInputAction: TextInputAction.search,
                          keyboardAppearance:
                          isDark ? Brightness.dark : Brightness.light,
                          cursorColor: colorScheme.primary,
                          onChanged: (String val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'search_country'.tr,
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.black.withValues(alpha: 0.4),
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? CupertinoButton(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(32, 32),
                              onPressed: _clearSearch,
                              child: Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.black.withValues(alpha: 0.4),
                                size: 18,
                              ),
                            )
                                : null,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // List Body
              Expanded(
                child: _buildBody(context, cardColor, borderColor, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      Color cardColor,
      Color borderColor,
      bool isDark,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    final List<Country> filtered = _filteredCountries;

    if (filtered.isEmpty) {
      return CountrySearchEmptyState(query: _searchQuery);
    }

    if (_searchQuery.trim().isEmpty) {
      final List<Country> favorites = _favoriteCountries;

      return ListView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 30),
        children: [
          if (favorites.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
              child: Text(
                'FAVORITES',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            _buildCountryCard(favorites, cardColor, borderColor, isDark),
            const SizedBox(height: 20),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
            child: Text(
              'ALL COUNTRIES',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
          _buildCountryCard(filtered, cardColor, borderColor, isDark),
        ],
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 30),
      children: [
        _buildCountryCard(filtered, cardColor, borderColor, isDark),
      ],
    );
  }

  Widget _buildCountryCard(
      List<Country> countries,
      Color cardColor,
      Color borderColor,
      bool isDark,
      ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List<Widget>.generate(
          countries.length,
              (int index) {
            final Country country = countries[index];
            final bool showDivider = index < countries.length - 1;

            final String phoneCode = country.phoneCode.startsWith('+')
                ? country.phoneCode
                : '+${country.phoneCode}';

            final bool isSelected =
                widget.controller.selectedCountryCode.value == phoneCode;

            return Column(
              children: [
                CountrySearchTile(
                  country: country,
                  phoneCode: phoneCode,
                  query: _searchQuery,
                  isSelected: isSelected,
                  onTap: () {
                    try {
                      (widget.controller as dynamic).selectCountry(
                        phoneCode,
                        country.name,
                        country.flagEmoji,
                      );
                    } catch (_) {
                      widget.controller.selectCountry(phoneCode, country.name);
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop();
                  },
                ),
                if (showDivider)
                  Padding(
                    padding: const EdgeInsets.only(left: 68),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: borderColor,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}