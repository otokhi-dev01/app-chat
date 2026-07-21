import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AddPostCameraPreview
    extends StatelessWidget {
  final CameraController? controller;
  final bool loading;
  final bool showGrid;
  final String errorMessage;
  final VoidCallback onRetry;

  AddPostCameraPreview({
    super.key,
    required this.controller,
    required this.loading,
    required this.showGrid,
    required this.errorMessage,
    required this.onRetry,
  });

  bool get isReady {
    return controller != null &&
        controller!.value.isInitialized;
  }

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _CameraFeed(
            controller: controller!,
          ),
          if (showGrid)
            _CameraGrid(),
        ],
      );
    }

    if (loading) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5,
        ),
      );
    }

    return _CameraErrorView(
      message: errorMessage,
      onRetry: onRetry,
    );
  }
}

class _CameraFeed extends StatelessWidget {
  final CameraController controller;

  _CameraFeed({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Size? previewSize =
        controller.value.previewSize;

    if (previewSize == null) {
      return CameraPreview(
        controller,
      );
    }

    return LayoutBuilder(
      builder: (
          BuildContext context,
          BoxConstraints constraints,
          ) {
        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: previewSize.height,
                height: previewSize.width,
                child: CameraPreview(
                  controller,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CameraGrid extends StatelessWidget {
  _CameraGrid();

  @override
  Widget build(BuildContext context) {
    Color lineColor =
    Colors.white.withValues(
      alpha: 0.32,
    );

    return IgnorePointer(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
              -0.33,
              0,
            ),
            child: Container(
              width: 0.7,
              color: lineColor,
            ),
          ),
          Align(
            alignment: Alignment(
              0.33,
              0,
            ),
            child: Container(
              width: 0.7,
              color: lineColor,
            ),
          ),
          Align(
            alignment: Alignment(
              0,
              -0.33,
            ),
            child: Container(
              height: 0.7,
              color: lineColor,
            ),
          ),
          Align(
            alignment: Alignment(
              0,
              0.33,
            ),
            child: Container(
              height: 0.7,
              color: lineColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  _CameraErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.error
                  .withValues(
                alpha: 0.16,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.no_photography_outlined,
              color: colorScheme.error,
              size: 31,
            ),
          ),
          SizedBox(height: 14),
          Text(
            message.isEmpty
                ? 'Unable to open camera'
                : message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: Icon(
              Icons.refresh_rounded,
              size: 18,
            ),
            label: Text(
              'Retry',
            ),
          ),
        ],
      ),
    );
  }
}