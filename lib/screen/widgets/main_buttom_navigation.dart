import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/navigation/main_navigation_controller.dart';
import 'navigation/nav_drag_state.dart';
import 'navigation/navigation_item.dart';

class MainBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int unreadCount;
  final ImageProvider? profileImage;

  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.unreadCount = 0,
    this.profileImage,
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

  void _measure() {
    if (!mounted || _drag.isDragging) return;

    BuildContext? stackContext = _stackKey.currentContext;
    BuildContext? activeContext = _itemKeys[widget.currentIndex].currentContext;

    if (stackContext == null || activeContext == null) return;

    RenderBox stackBox = stackContext.findRenderObject() as RenderBox;
    RenderBox activeBox = activeContext.findRenderObject() as RenderBox;

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
                    Row(
                      children: [
                        _buildItem(
                          index: MainTab.chats.index,
                          displayIndex: displayIndex,
                          icon: Icons.chat_bubble_outline_rounded,
                          activeIcon: Icons.chat_bubble_rounded,
                          label: 'chats'.tr,
                          badgeCount: widget.unreadCount,
                          backgroundColor: backgroundColor,
                        ),
                        _buildItem(
                          index: MainTab.contacts.index,
                          displayIndex: displayIndex,
                          icon: Icons.people_outline_rounded,
                          activeIcon: Icons.people_rounded,
                          label: 'contacts'.tr,
                          backgroundColor: backgroundColor,
                        ),
                        _buildItem(
                          index: MainTab.settings.index,
                          displayIndex: displayIndex,
                          icon: Icons.settings_outlined,
                          activeIcon: Icons.settings_rounded,
                          label: 'settings'.tr,
                          backgroundColor: backgroundColor,
                        ),
                        _buildItem(
                          index: MainTab.profile.index,
                          displayIndex: displayIndex,
                          icon: Icons.person_outline_rounded,
                          activeIcon: Icons.person_rounded,
                          label: 'profile'.tr,
                          profileImage: widget.profileImage,
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
      // No animation while dragging — tracks the finger 1:1.
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
    ImageProvider? profileImage,
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
        profileImage: profileImage,
        navigationBackground: backgroundColor,
        onTap: widget.onTap,
      ),
    );
  }
}