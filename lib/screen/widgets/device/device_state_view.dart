import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevicesLoadingView extends StatelessWidget {
  DevicesLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.6,
        color: colorScheme.primary,
      ),
    );
  }
}

class DevicesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  DevicesErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: colorScheme.error,
                  size: 31,
                ),
              ),

              SizedBox(height: 14),

              Text(
                'unable_to_load_devices'.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 7),

              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 18),

              FilledButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 19,
                ),
                label: Text(
                  'try_again'.tr,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: Size(
                    double.infinity,
                    48,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}