import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import 'home_category_filter.dart';

class HomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedIndex;
  final List<String> titles;
  final HomeController controller;

  const HomeAppBar({
    super.key,
    required this.selectedIndex,
    required this.titles,
    required this.controller,
  });

  @override
  Size get preferredSize {
    // Height stays fixed for tab 0 whether it's showing the category
    // filter or the search field — only the content inside animates.
    final double bottomHeight = selectedIndex == 0 ? 74 : 0;

    return Size.fromHeight(
      kToolbarHeight + bottomHeight,
    );
  }

  List<Widget> _buildActions() {
    switch (selectedIndex) {
      case 0:
        return [
          IconButton(
            tooltip: 'Search chats',
            onPressed: controller.openSearchScreen,
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'More',
            onPressed: () {
              // More chat options
            },
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
        ];

      case 1:
        return [
          IconButton(
            tooltip: 'Search contacts',
            onPressed: () {
              // Search contacts
            },
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Add contact',
            onPressed: () {
              // Add contact
            },
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
            ),
          ),
        ];

      case 2:
        return [
          IconButton(
            tooltip: 'Search settings',
            onPressed: () {
              // Search settings
            },
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
        ];

      case 3:
        return [
          IconButton(
            tooltip: 'Edit profile',
            onPressed: () {
              // Edit profile
            },
            icon: const Icon(
              Icons.edit_rounded,
            ),
          ),
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    // ClipRect + BackdropFilter gives the app bar the same frosted-glass
    // look as the bottom nav, so the chat list is faintly visible/blurred
    // underneath it rather than hidden behind a solid bar.
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AppBar(
          elevation: 0,
          scrolledUnderElevation: 1,
          titleSpacing: 16,
          surfaceTintColor: Colors.transparent,
          backgroundColor: isDark
              ? const Color(0xFF171A1F).withValues(alpha: 0.72)
              : Colors.white.withValues(alpha: 0.72),

          title: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 220,
            ),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              titles[selectedIndex],
              key: ValueKey<int>(selectedIndex),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          actions: _buildActions(),

          bottom: selectedIndex == 0
              ? PreferredSize(
            preferredSize: const Size.fromHeight(74),
            child: Obx(
                  () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1,
                      child: child,
                    ),
                  );
                },
                child: controller.isSearching.value
                    ? _SearchBarPreview(
                  key: const ValueKey('search'),
                  controller: controller,
                )
                    : HomeCategoryFilter(
                  key: const ValueKey('filter'),
                  controller: controller,
                ),
              ),
            ),
          )
              : null,
        ),
      ),
    );
  }
}

/// Non-editable pinned search bar shown while the chat list is scrolled
/// down. Tapping it opens the dedicated SearchScreen — it never accepts
/// typing itself.
class _SearchBarPreview extends StatelessWidget {
  final HomeController controller;

  const _SearchBarPreview({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: controller.openSearchScreen,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.black.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search chats',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}