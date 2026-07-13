import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double padding;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.size = 100,
    this.padding = 0,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor =
    colorScheme.primary.withValues(alpha: 0.20);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: Container(
          color: backgroundColor,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/icon/app_icon.jpg',
            width: size,
            height: size,
            fit: fit,
            filterQuality: FilterQuality.high,
            errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
                ) {
              return Container(
                color: colorScheme.primary.withValues(
                  alpha: 0.11,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.chat_rounded,
                  size: size * 0.50,
                  color: colorScheme.primary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}