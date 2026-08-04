import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/app_feedback.dart';

class QrScannerMessage extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const QrScannerMessage({
    super.key,
    required this.message,
    required this.onClose,
  });

  /// Helper method to trigger AppFeedback snackbar toast directly
  static void showFeedback(String message) {
    AppFeedback.showMessage(
      title: 'error'.tr,
      message: message,
      icon: CupertinoIcons.exclamationmark_circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.error,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          14,
          10,
          8,
          10,
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle,
              color: colorScheme.onError,
              size: 21,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colorScheme.onError,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size(32, 32),
              onPressed: onClose,
              child: Icon(
                CupertinoIcons.xmark,
                color: colorScheme.onError,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QrCameraLoadingView extends StatelessWidget {
  const QrCameraLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: colorScheme.primary,
      ),
    );
  }
}

class QrCameraErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const QrCameraErrorView({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      color: Color(0xFF111216),
      alignment: Alignment.center,
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 74,
            height: 74,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(
                alpha: 0.14,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.camera,
              color: colorScheme.error,
              size: 34,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'camera_unavailable'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'check_camera_permission'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(
                alpha: 0.65,
              ),
              fontSize: 13,
            ),
          ),
          SizedBox(height: 20),
          Material(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(
              16,
            ),
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(
                16,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                child: Text(
                  'try_again'.tr,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrScannerProcessingView extends StatelessWidget {
  final Color color;

  const QrScannerProcessingView({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(
        alpha: 0.26,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(
            alpha: 0.72,
          ),
          borderRadius: BorderRadius.circular(
            22,
          ),
          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.12,
            ),
          ),
        ),
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color,
        ),
      ),
    );
  }
}