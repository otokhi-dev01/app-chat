import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// UPDATED: Unit UI floating action button that smoothly slides and fades in to scroll the chat to the bottom
class ChatScrollToBottomButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;

  const ChatScrollToBottomButton({
    super.key,
    required this.visible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // UPDATED: Retrieve current theme and brightness state for dynamic dark/light mode adaptation
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    // UPDATED: Standardized unit UI container background and subtle border colors
    Color buttonBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Positioned(
      right: 14,
      bottom: 96, // UPDATED: Positioned directly above sticky bottom ChatInputBar
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        offset: visible ? Offset.zero : const Offset(0, 1.8),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: visible ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: !visible,
            child: Tooltip(
              message: 'Scroll to bottom',
              // UPDATED: Unit UI circular container with border, subtle drop shadow, and clip behavior
              child: Container(
                width: 42,
                height: 42,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: buttonBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.22 : 0.08,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // UPDATED: Switched to CupertinoButton with zero padding for crisp iOS tap response
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(42, 42),
                  onPressed: onTap,
                  // UPDATED: Replaced Material icon with Cupertino chevron icon
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}