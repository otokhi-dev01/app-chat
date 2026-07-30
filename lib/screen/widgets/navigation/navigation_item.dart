import 'package:flutter/material.dart';

import 'navigation_icon.dart';

class NavigationItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final ValueChanged<int> onTap;
  final int badgeCount;
  final ImageProvider? profileImage;
  final Color navigationBackground;

  const NavigationItem({
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
            if (isSelected) return;
            onTap(index);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavigationIcon(
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