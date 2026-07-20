import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/navigation/main_navigation_controller.dart';

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
  State<MainBottomNavigation> createState() {
    return _MainBottomNavigationState();
  }
}

class _MainBottomNavigationState
    extends State<MainBottomNavigation> {
  final GlobalKey _stackKey = GlobalKey();

  final List<GlobalKey> _itemKeys = List.generate(
    4,
        (_) => GlobalKey(),
  );

  Rect? _indicatorRect;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });
  }

  @override
  void didUpdateWidget(
      MainBottomNavigation oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });
  }

  void _measure() {
    if (!mounted) {
      return;
    }

    GlobalKey activeKey =
    _itemKeys[widget.currentIndex];

    BuildContext? stackContext =
        _stackKey.currentContext;

    BuildContext? activeContext =
        activeKey.currentContext;

    if (stackContext == null ||
        activeContext == null) {
      return;
    }

    RenderBox stackBox =
    stackContext.findRenderObject() as RenderBox;

    RenderBox activeBox =
    activeContext.findRenderObject() as RenderBox;

    Offset offset = activeBox.localToGlobal(
      Offset.zero,
      ancestor: stackBox,
    );

    Rect rect = offset & activeBox.size;

    if (rect != _indicatorRect) {
      setState(() {
        _indicatorRect = rect;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final ColorScheme colorScheme = theme.colorScheme;

    final Color backgroundColor =
    isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final Color activeBackground =
    colorScheme.primary.withValues(alpha: 0.11);

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
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Stack(
            key: _stackKey,
            children: [
              if (_indicatorRect != null)
                AnimatedPositioned(
                  duration: const Duration(
                    milliseconds: 260,
                  ),
                  curve: Curves.easeOutCubic,
                  left: _indicatorRect!.left,
                  top: _indicatorRect!.top,
                  width: _indicatorRect!.width,
                  height: _indicatorRect!.height,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: activeBackground,
                      borderRadius:
                      BorderRadius.circular(22),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: _NavigationItem(
                      key: _itemKeys[MainTab.chats.index],
                      index: MainTab.chats.index,
                      currentIndex: widget.currentIndex,
                      icon: Icons.chat_bubble_outline_rounded,
                      activeIcon: Icons.chat_bubble_rounded,
                      label: 'chats'.tr,
                      badgeCount: widget.unreadCount,
                      navigationBackground: backgroundColor,
                      onTap: widget.onTap,
                    ),
                  ),
                  Expanded(
                    child: _NavigationItem(
                      key: _itemKeys[MainTab.contacts.index],
                      index: MainTab.contacts.index,
                      currentIndex: widget.currentIndex,
                      icon: Icons.people_outline_rounded,
                      activeIcon: Icons.people_rounded,
                      label: 'contacts'.tr,
                      navigationBackground: backgroundColor,
                      onTap: widget.onTap,
                    ),
                  ),
                  Expanded(
                    child: _NavigationItem(
                      key: _itemKeys[MainTab.settings.index],
                      index: MainTab.settings.index,
                      currentIndex: widget.currentIndex,
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings_rounded,
                      label: 'settings'.tr,
                      navigationBackground: backgroundColor,
                      onTap: widget.onTap,
                    ),
                  ),
                  Expanded(
                    child: _NavigationItem(
                      key: _itemKeys[MainTab.profile.index],
                      index: MainTab.profile.index,
                      currentIndex: widget.currentIndex,
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'profile'.tr,
                      profileImage: widget.profileImage,
                      navigationBackground: backgroundColor,
                      onTap: widget.onTap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final ValueChanged<int> onTap;
  final int badgeCount;
  final ImageProvider? profileImage;
  final Color navigationBackground;

  const _NavigationItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.navigationBackground,
    required this.onTap,
    this.badgeCount = 0,
    this.profileImage,
  });

  bool get isSelected => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Color primary = colorScheme.primary;
    final Color inactiveColor = colorScheme.onSurfaceVariant;

    // Background highlight is now handled by the shared sliding
    // indicator in MainBottomNavigation, so this item only renders
    // its own content (icon + label), no background of its own.
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: () {
            if (isSelected) {
              return;
            }
            onTap(index);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavigationIcon(
                  selected: isSelected,
                  icon: icon,
                  activeIcon: activeIcon,
                  primary: primary,
                  inactiveColor: inactiveColor,
                  badgeCount: badgeCount,
                  profileImage: profileImage,
                  navigationBackground: navigationBackground,
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    color: isSelected ? primary : inactiveColor,
                    fontSize: 10.5,
                    height: 1,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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

class _NavigationIcon extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final IconData activeIcon;
  final Color primary;
  final Color inactiveColor;
  final int badgeCount;
  final ImageProvider? profileImage;
  final Color navigationBackground;

  const _NavigationIcon({
    required this.selected,
    required this.icon,
    required this.activeIcon,
    required this.primary,
    required this.inactiveColor,
    required this.badgeCount,
    required this.navigationBackground,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget iconWidget;

    if (profileImage != null) {
      iconWidget = AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 29,
        height: 29,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: profileImage,
          backgroundColor: colorScheme.surfaceContainerHighest,
        ),
      );
    } else {
      iconWidget = SizedBox(
        width: 38,
        height: 29,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                  ) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                selected ? activeIcon : icon,
                key: ValueKey<bool>(selected),
                size: 26,
                color: selected ? primary : inactiveColor,
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -5,
                right: -3,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: navigationBackground,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 9,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return AnimatedScale(
      scale: selected ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      child: iconWidget,
    );
  }
}