import 'dart:ui'; // Required for ImageFilter

import 'package:appchat/controllers/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeCategoryFilter extends StatelessWidget {
  final ChatController controller;

  const HomeCategoryFilter({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
          () {
        int activeIndex = controller.selectedCategoryIndex.value;
        List chats = controller.chats.toList();

        int getCount(int index) {
          switch (index) {
            case 1:
              return chats.where((chat) => chat.unread > 0).length;
            case 2:
              return chats.where((chat) => chat.type == 'personal').length;
            case 3:
              return chats.where((chat) => chat.type == 'group').length;
            case 4:
              return chats.where((chat) => chat.type == 'work').length;
            default:
              return chats.length;
          }
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
          child: ClipRRect(
            // Clips the blur effect to the rounded corners of the filter bar
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              // Applies the frosted glass blur effect
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  // Dynamic background: Matches pure white (light) or Telegram surface blue-gray (dark)
                  color: isDark
                      ? const Color(0xFF17212B).withValues(alpha: 0.45)
                      : Colors.white.withValues(alpha: 0.50),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.04,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.zero,
                  itemCount: controller.categories.length,
                  separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 4),
                  itemBuilder: (BuildContext context, int index) {
                    bool isActive = activeIndex == index;
                    int count = getCount(index);

                    return _CategoryItem(
                      label: controller.categories[index],
                      count: count,
                      isActive: isActive,
                      isDark: isDark,
                      onTap: () {
                        if (isActive) return;
                        HapticFeedback.selectionClick();
                        controller.selectCategory(index);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color primaryColor = colorScheme.primary;

    Color inactiveTextColor =
    isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    Color activeTextColor = primaryColor;

    // Background dynamically uses current ThemeData's primary color
    Color itemBackground = isActive
        ? primaryColor.withValues(alpha: isDark ? 0.18 : 0.12)
        : isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.grey.shade100;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        highlightColor: Colors.transparent,
        splashColor: primaryColor.withValues(alpha: 0.12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minWidth: 82),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: itemBackground,
            border: Border.all(
              color: isActive
                  ? primaryColor.withValues(alpha: 0.18)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
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
              if (count > 0) ...[
                const SizedBox(width: 5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: count > 99 ? 25 : 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isActive
                        ? primaryColor.withValues(alpha: 0.18)
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
    );
  }
}