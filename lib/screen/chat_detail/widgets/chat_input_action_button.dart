import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// UPDATED: Unit UI circular action button used for quick actions (e.g. attach media) in the chat input bar
class ChatInputActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const ChatInputActionButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // UPDATED: Standardized 44x44 circular button container with clip behavior and dynamic icon opacity
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 44,
        height: 44,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        // UPDATED: Replaced InkWell/Material with CupertinoButton for zero-lag iOS press animation
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size(44, 44),
          onPressed: onPressed,
          child: Icon(
            icon,
            color: onPressed == null
                ? iconColor.withValues(alpha: 0.40)
                : iconColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}