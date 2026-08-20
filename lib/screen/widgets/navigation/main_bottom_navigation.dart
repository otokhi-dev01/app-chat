import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/navigation/main_navigation_controller.dart';
import 'nav_drag_state.dart';
import 'navigation_item.dart';

/// UPDATED: MainBottomNavigation featuring a 3 + 1 split layout (Chats, Contacts, Calls on left; Search on right)
class MainBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int unreadCount;

  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.unreadCount = 0,
  });

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  final GlobalKey _stackKey = GlobalKey();
  final List<GlobalKey> _itemKeys = List.generate(4, (_) => GlobalKey());

  Rect? _indicatorRect;
  NavDragState _drag = NavDragState.idle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(MainBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  /// UPDATED: Dynamically measures active item bounds to position indicator smoothly across split layout
  void _measure() {
    if (!mounted || _drag.isDragging) return;

    BuildContext? stackContext = _stackKey.currentContext;
    BuildContext? activeContext = _itemKeys[widget.currentIndex].currentContext;

    if (stackContext == null || activeContext == null) return;

    RenderBox? stackBox = stackContext.findRenderObject() as RenderBox?;
    RenderBox? activeBox = activeContext.findRenderObject() as RenderBox?;

    if (stackBox == null || activeBox == null) return;
    if (!stackBox.hasSize || !activeBox.hasSize) return;

    Offset offset = activeBox.localToGlobal(Offset.zero, ancestor: stackBox);
    Rect rect = offset & activeBox.size;

    if (rect != _indicatorRect) {
      setState(() => _indicatorRect = rect);
    }
  }

  void _handleDragStart(LongPressStartDetails details) {
    if (_indicatorRect == null) return;

    HapticFeedback.selectionClick();
    setState(() {
      _drag = _drag.start(
        startLeft: _indicatorRect!.left,
        startIndex: widget.currentIndex,
      );
    });
  }

  void _handleDragUpdate(LongPressMoveUpdateDetails details, double totalWidth) {
    if (!_drag.isDragging || _indicatorRect == null) return;

    NavDragState next = _drag.update(
      details: details,
      totalWidth: totalWidth,
      indicatorWidth: _indicatorRect!.width,
      itemCount: _itemKeys.length,
    );

    if (next.hoveredIndex != _drag.hoveredIndex) {
      HapticFeedback.selectionClick();
    }

    setState(() => _drag = next);
  }

  void _handleDragEnd(LongPressEndDetails details) {
    if (!_drag.isDragging) return;

    int? finalIndex = _drag.hoveredIndex;
    setState(() => _drag = NavDragState.idle);

    if (finalIndex != null && finalIndex != widget.currentIndex) {
      widget.onTap(finalIndex);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    }
  }

  void _handleDragCancel() {
    if (!_drag.isDragging) return;
    setState(() => _drag = NavDragState.idle);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final ColorScheme colorScheme = theme.colorScheme;

    final Color backgroundColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final Color activeBackground = colorScheme.primary.withValues(alpha: 0.11);

    int displayIndex = _drag.isDragging
        ? (_drag.hoveredIndex ?? widget.currentIndex)
        : widget.currentIndex;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          height: 68,
          padding: const EdgeInsets.all(4),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: borderColor),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double totalWidth = constraints.maxWidth;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onLongPressStart: _handleDragStart,
                onLongPressMoveUpdate: (details) =>
                    _handleDragUpdate(details, totalWidth),
                onLongPressEnd: _handleDragEnd,
                onLongPressCancel: _handleDragCancel,
                child: Stack(
                  key: _stackKey,
                  children: [
                    _buildIndicator(activeBackground),
                    // UPDATED: Split Row layout placing 3 main tabs on left and 1 search tab on right
                    Row(
                      children: [
                        // --- LEFT GROUP (3 Buttons: Chats, Contacts, Calls) ---
                        _buildItem(
                          index: MainTab.chats.index,
                          displayIndex: displayIndex,
                          icon: CupertinoIcons.chat_bubble_2,
                          activeIcon: CupertinoIcons.chat_bubble_2_fill,
                          label: 'chats'.tr,
                          badgeCount: widget.unreadCount,
                          backgroundColor: backgroundColor,
                        ),
                        _buildItem(
                          index: MainTab.contacts.index,
                          displayIndex: displayIndex,
                          icon: CupertinoIcons.person_2,
                          activeIcon: CupertinoIcons.person_2_fill,
                          label: 'contacts'.tr,
                          backgroundColor: backgroundColor,
                        ),
                        _buildItem(
                          index: MainTab.calls.index,
                          displayIndex: displayIndex,
                          icon: CupertinoIcons.phone,
                          activeIcon: CupertinoIcons.phone_fill,
                          label: 'calls'.tr,
                          backgroundColor: backgroundColor,
                        ),

                        // ADDED: Subtle 1px vertical divider separating 3 left tabs from 1 right search tab
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 2,
                          ),
                          child: Container(
                            width: 1,
                            color: borderColor,
                          ),
                        ),

                        // --- RIGHT GROUP (1 Button: Search) ---
                        _buildItem(
                          index: MainTab.search.index,
                          displayIndex: displayIndex,
                          icon: CupertinoIcons.search,
                          activeIcon: CupertinoIcons.search,
                          label: 'search'.tr,
                          backgroundColor: backgroundColor,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(Color activeBackground) {
    if (_indicatorRect == null) return const SizedBox.shrink();

    if (_drag.isDragging && _drag.indicatorLeft != null) {
      return Positioned(
        left: _drag.indicatorLeft!,
        top: _indicatorRect!.top,
        width: _indicatorRect!.width,
        height: _indicatorRect!.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: activeBackground,
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      );
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      left: _indicatorRect!.left,
      top: _indicatorRect!.top,
      width: _indicatorRect!.width,
      height: _indicatorRect!.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: activeBackground,
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required int displayIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color backgroundColor,
    int badgeCount = 0,
  }) {
    return Expanded(
      child: NavigationItem(
        key: _itemKeys[index],
        index: index,
        currentIndex: displayIndex,
        icon: icon,
        activeIcon: activeIcon,
        label: label,
        badgeCount: badgeCount,
        navigationBackground: backgroundColor,
        onTap: widget.onTap,
      ),
    );
  }
}