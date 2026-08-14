import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/search/search_controller.dart';

/// ADDED: Standalone search input field widget extracted from SearchAppBar
class SearchInputField extends StatelessWidget {
  final ChatSearchController controller;
  final VoidCallback onClear;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color searchBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: searchBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
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
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            CupertinoIcons.search,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              autofocus: true,
              onChanged: controller.updateSearch,
              onSubmitted: (String value) {
                controller.search(value);
              },
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              enableSuggestions: true,
              autocorrect: true,
              cursorColor: colorScheme.primary,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'search_chats'.tr,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.4),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 11,
                ),
              ),
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          Obx(() {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox(width: 12);
            }

            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(32, 32),
                onPressed: onClear,
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  size: 18,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.4),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}