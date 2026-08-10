import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// UPDATED: Glassmorphic floating bottom search bar with true translucent frosted glass styling (no stark white block)
class CountrySearchInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onCancel;

  const CountrySearchInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    // FIXED: Lowered opacity (70% light / 68% dark) and increased blur for true frosted glass that blends seamlessly without a heavy white block when keyboard closes
    Color searchBackground = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.68)
        : Colors.white.withValues(alpha: 0.70);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.06);

    return Row(
      children: [
        // Glassmorphic Search Field Container
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: searchBackground,
                  borderRadius: BorderRadius.circular(23),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.18 : 0.04,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  keyboardAppearance:
                  isDark ? Brightness.dark : Brightness.light,
                  cursorColor: colorScheme.primary,
                  onChanged: onChanged,
                  // IMPROVED: Automatically dismisses keyboard when tapping outside input field
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'search_country'.tr,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.45)
                          : Colors.black.withValues(alpha: 0.40),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                    // FIXED: Clear text 'X' button when query is active
                    suffixIcon: searchQuery.isNotEmpty
                        ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(32, 32),
                      onPressed: onClear,
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.45)
                            : Colors.black.withValues(alpha: 0.35),
                        size: 18,
                      ),
                    )
                        : null,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // REPLACED: Circular frosted glass 'X' close button matching search field styling
        ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: searchBackground,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.18 : 0.04,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onCancel,
                child: Icon(
                  CupertinoIcons.xmark,
                  color: colorScheme.onSurface,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}