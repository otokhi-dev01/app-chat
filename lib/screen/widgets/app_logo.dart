import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;

  /// Show a glowing effect around the logo.
  final bool showGlow;

  const AppLogo({
    super.key,
    this.width = 100,
    this.showGlow = false,
  }) : assert(width > 0);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double glowSpread = width * 0.08;

    return RepaintBoundary(
      child: Semantics(
        label: 'Pii Chat logo',
        image: true,
        child: Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            boxShadow: showGlow
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.55),
                      blurRadius: glowSpread * 2.5,
                      spreadRadius: glowSpread * 0.5,
                    ),
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: glowSpread * 5,
                      spreadRadius: glowSpread,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Image.asset(
            'assets/icon/pii_chat.jpg',
            width: width,
            height: width,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            gaplessPlayback: true,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return Container(
                width: width,
                height: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.chat_rounded,
                  size: width * 0.45,
                  color: Colors.white,
                ),
              );
            },
          ),
          ),
        ),
      ),
    );
  }
}