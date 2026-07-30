import 'package:flutter/material.dart';

class NavigationIcon extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final IconData activeIcon;
  final Color primary;
  final Color inactiveColor;
  final int badgeCount;
  final ImageProvider? profileImage;
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
            if (badgeCount > 0)
              Positioned(
                top: -5,
                right: -3,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: navigationBackground, width: 1.5),
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