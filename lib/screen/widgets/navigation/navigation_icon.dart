import 'package:flutter/material.dart';

class NavigationIcon extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final IconData activeIcon;
  final Color primary;
  final Color inactiveColor;
  final int badgeCount;
  final Color navigationBackground;

  const NavigationIcon({
    super.key,
    required this.selected,
    required this.icon,
    required this.activeIcon,
    required this.primary,
    required this.inactiveColor,
    required this.badgeCount,
    required this.navigationBackground,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: selected ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      child: SizedBox(
        width: 38,
        height: 29,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Smooth switcher between inactive and active icons
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                selected ? activeIcon : icon,
                key: ValueKey<bool>(selected),
                size: 26,
                color: selected ? primary : inactiveColor,
              ),
            ),

            // Badge count (for unread messages on chat, missed calls, etc.)
            if (badgeCount > 0)
              Positioned(
                top: -5,
                right: -3,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
      ),
    );
  }
}