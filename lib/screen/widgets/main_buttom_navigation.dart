import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainBottomNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

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
          child: Row(
            children: [
              Expanded(
                child: _NavigationItem(
                  index: 0,
                  currentIndex: currentIndex,
                  icon: Icons.chat_bubble_outline_rounded,
                  activeIcon: Icons.chat_bubble_rounded,
                  label: 'chats'.tr,
                  badgeCount: unreadCount,
                  navigationBackground: backgroundColor,
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: _NavigationItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.people_outline_rounded,
                  activeIcon: Icons.people_rounded,
                  label: 'contacts'.tr,
                  navigationBackground: backgroundColor,
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: _NavigationItem(
                  index: 2,
                  currentIndex: currentIndex,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'settings'.tr,
                  navigationBackground: backgroundColor,
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: _NavigationItem(
                  index: 3,
                  currentIndex: currentIndex,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'profile'.tr,
                  profileImage: profileImage,
                  navigationBackground: backgroundColor,
                  onTap: onTap,
                ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color primary = colorScheme.primary;
    final Color inactiveColor =
        colorScheme.onSurfaceVariant;

    final Color selectedBackground =
    primary.withValues(alpha: 0.11);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        highlightColor: Colors.transparent,
        splashColor: primary.withValues(alpha: 0.10),
        onTap: () {
          if (isSelected) {
            return;
          }

          HapticFeedback.selectionClick();
          onTap(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedBackground
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
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
                navigationBackground:
                navigationBackground,
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: isSelected
                      ? primary
                      : inactiveColor,
                  fontSize: 10.5,
                  height: 1,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
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
    final colorScheme = Theme.of(context).colorScheme;

    if (profileImage != null) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 29,
        height: 29,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: profileImage,
          backgroundColor:
          colorScheme.surfaceContainerHighest,
        ),
      );
    }

    return SizedBox(
      width: 38,
      height: 29,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
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
              color: selected
                  ? primary
                  : inactiveColor,
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
                  badgeCount > 99
                      ? '99+'
                      : badgeCount.toString(),
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
}