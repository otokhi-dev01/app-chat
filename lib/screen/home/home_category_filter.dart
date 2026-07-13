import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/home_controller.dart';
import '../../core/theme/app_theme.dart';

class HomeCategoryFilter extends StatelessWidget {
  final HomeController controller;

  const HomeCategoryFilter({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final int activeIndex = controller.selectedCategoryIndex.value;
      final chats = controller.chats.toList();

      int getCount(int index) {
        switch (index) {
          case 1:
            return chats.where((chat) => chat.unread > 0).length;
          case 2:
            return chats.where((chat) => chat.type == 'personal').length;
          case 3:
            return chats.where((chat) => chat.type == 'group').length;
          default:
            return chats.length;
        }
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF171A1F).withValues(alpha: 0.82)
                    : Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : Colors.black.withValues(alpha: 0.08),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.09),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(
                  controller.categories.length,
                      (index) {
                    final bool isActive = activeIndex == index;
                    final int count = getCount(index);

                    return Expanded(
                      child: _CategoryItem(
                        label: controller.categories[index],
                        count: count,
                        isActive: isActive,
                        isDark: isDark,
                        onTap: () {
                          if (isActive) return;
                          HapticFeedback.selectionClick();
                          controller.selectCategory(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.label,
    required this.count,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color inactiveTextColor =
    isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    // Active state now just uses the brand color — no glass highlight box.
    final Color activeTextColor = AppTheme.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        highlightColor: Colors.transparent,
        splashColor: AppTheme.primaryColor.withValues(alpha: 0.12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.grey.shade100,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      color: isActive ? activeTextColor : inactiveTextColor,
                      fontSize: 12,
                      height: 1,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppTheme.primaryColor.withValues(alpha: 0.18)
                          : isDark
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.grey.shade200,
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: TextStyle(
                        color: isActive ? activeTextColor : inactiveTextColor,
                        fontSize: count > 99 ? 8 : 9,
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}