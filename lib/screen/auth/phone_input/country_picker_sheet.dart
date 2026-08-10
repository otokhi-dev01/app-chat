import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../auth/telegram_login_controller.dart';
import 'country_search_empty_state.dart';
import 'country_search_input.dart';
import 'country_search_title.dart';

/// IMPROVED: CountryPickerSheet entry point providing floating bottom search and smooth UX transitions
class CountryPickerSheet {
  CountryPickerSheet._();

  /// Opens the country picker modal sheet with bottom floating search and smooth keyboard handling
  static Future<void> show({
    required BuildContext context,
    required TelegramLoginController controller,
    List<String>? favoriteIsoCodes,
  }) async {
    // IMPROVED: Unfocus active primary focus before launching bottom sheet to prevent keyboard collision
    FocusManager.instance.primaryFocus?.unfocus();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      useRootNavigator: true,
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

  // IMPROVED: Added ScrollController to reset list scroll position back to top when search query updates
  final ScrollController _listScrollController = ScrollController();

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
    _listScrollController.dispose();
    super.dispose();
  }

  /// IMPROVED: Clears search text and scrolls country list back to top smoothly
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _scrollToTop();
  }

  /// IMPROVED: Helper to animate scroll position back to top when search query changes
  void _scrollToTop() {
    if (_listScrollController.hasClients) {
      _listScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    }
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

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double systemBottomPadding = MediaQuery.of(context).padding.bottom;
    final double sheetHeight = screenHeight * 0.85;

    // IMPROVED: Dynamically calculates bottom margin for floating search bar accounting for gesture bar and keyboard
    final double searchBottomMargin =
        12 + (keyboardHeight == 0 ? systemBottomPadding : 0);

    return GestureDetector(
      // IMPROVED: Tapping anywhere outside the search bar dismisses the soft keyboard cleanly
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: sheetHeight,
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        // IMPROVED: Smooth 180ms padding transition when keyboard slides up or down
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              children: [
                // IMPROVED: Main scrollable country list body filling full sheet height
                Positioned.fill(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Top Drag Handle
                      Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Country List Body
                      Expanded(
                        child: _buildBody(
                          context,
                          cardColor,
                          borderColor,
                          isDark,
                          systemBottomPadding,
                        ),
                      ),
                    ],
                  ),
                ),

                // IMPROVED: Floating glass search input pinned at the bottom above keyboard/gesture bar
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: searchBottomMargin,
                  child: CountrySearchInput(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    searchQuery: _searchQuery,
                    onChanged: (String val) {
                      setState(() {
                        _searchQuery = val;
                      });
                      _scrollToTop();
                    },
                    onClear: _clearSearch,
                    onCancel: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
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
      double systemBottomPadding,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    final List<Country> filtered = _filteredCountries;

    if (filtered.isEmpty) {
      return CountrySearchEmptyState(query: _searchQuery);
    }

    // IMPROVED: Bottom list padding ensures last country card is fully visible above floating search bar
    final EdgeInsets listPadding =
    EdgeInsets.fromLTRB(14, 4, 14, 76 + systemBottomPadding);

    if (_searchQuery.trim().isEmpty) {
      final List<Country> favorites = _favoriteCountries;

      return ListView(
        controller: _listScrollController,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: listPadding,
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
      controller: _listScrollController,
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: listPadding,
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
                    // IMPROVED: Added selection click haptic feedback for instant tactile response
                    HapticFeedback.selectionClick();
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