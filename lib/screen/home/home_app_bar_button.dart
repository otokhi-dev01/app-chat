import 'package:flutter/material.dart';

class HomeAppBarActionButton
    extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  HomeAppBarActionButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color currentIconColor = onPressed == null
        ? foregroundColor.withValues(alpha: 0.40)
        : foregroundColor;

    return Center(
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: backgroundColor,
          shape: CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: CircleBorder(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                icon,
                color: currentIconColor,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}