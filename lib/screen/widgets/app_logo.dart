import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double borderRadius;

  const AppLogo({
    super.key,
    this.width = 160,
    this.borderRadius = 16,
  })  : assert(width > 0),
        assert(borderRadius >= 0);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return RepaintBoundary(
      child: Semantics(
        label: 'OTOKHI Chat logo',
        image: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/icon/otokhi_app_logo.jpg',

            // Set only width.
            // Height follows the original image ratio.
            width: width,

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
                  color: colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(
                    borderRadius,
                  ),
                ),
                child: Icon(
                  Icons.chat_rounded,
                  size: width * 0.45,
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