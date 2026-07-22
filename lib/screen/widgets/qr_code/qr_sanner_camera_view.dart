import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'qr_scanner_auto_zoom.dart';
import 'qr_scanner_feedback.dart';
import 'qr_scanner_geometry.dart'
as scanner_geometry;
import 'qr_scanner_overlay.dart';

class QrScannerCameraView
    extends StatefulWidget {
  final MobileScannerController
  scannerController;

  final void Function(
      BarcodeCapture capture,
      ) onDetect;

  final VoidCallback onRetry;

  QrScannerCameraView({
    super.key,
    required this.scannerController,
    required this.onDetect,
    required this.onRetry,
  });

  @override
  State<QrScannerCameraView> createState() {
    return _QrScannerCameraViewState();
  }
}

class _QrScannerCameraViewState
    extends State<QrScannerCameraView> {
  late QrScannerAutoZoom
  _autoZoomController;

  bool _isHandlingCapture = false;

  @override
  void initState() {
    super.initState();

    _autoZoomController =
        QrScannerAutoZoom(
          controller:
          widget.scannerController,
        );
  }

  @override
  void didUpdateWidget(
      QrScannerCameraView oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scannerController !=
        widget.scannerController) {
      _autoZoomController =
          QrScannerAutoZoom(
            controller:
            widget.scannerController,
          );
    }
  }

  void _handleCapture(
      BarcodeCapture capture,
      ) {
    if (_isHandlingCapture) {
      return;
    }

    _isHandlingCapture = true;

    unawaited(
      _prepareCapture(capture),
    );
  }

  Future<void> _prepareCapture(
      BarcodeCapture capture,
      ) async {
    try {
      bool shouldProcess =
      await _autoZoomController
          .prepareCapture(
        capture,
      );

      if (!mounted ||
          !shouldProcess) {
        return;
      }

      widget.onDetect(
        capture,
      );
    } catch (error) {
      debugPrint(
        'QR capture error: $error',
      );
    } finally {
      _isHandlingCapture = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return OrientationBuilder(
      builder: (
          BuildContext context,
          Orientation orientation,
          ) {
        return LayoutBuilder(
          builder: (
              BuildContext context,
              BoxConstraints constraints,
              ) {
            double width =
                constraints.maxWidth;

            double height =
                constraints.maxHeight;

            if (!width.isFinite ||
                !height.isFinite ||
                width <= 0 ||
                height <= 0) {
              return QrCameraLoadingView();
            }

            Size layoutSize = Size(
              width,
              height,
            );

            // Pixel-space rect: used only for drawing the visible
            // overlay frame on screen.
            Rect scanWindowPixels =
            scanner_geometry
                .QrScannerGeometry
                .buildScanWindowPixels(
              screenSize: layoutSize,
              orientation: orientation,
            );

            // Normalized (0.0-1.0) rect: this is what
            // mobile_scanner's scanWindow parameter actually
            // requires. Passing pixel values here is what was
            // causing MOBILE_SCANNER_BARCODE_ERROR.
            Rect scanWindowNormalized =
            scanner_geometry
                .QrScannerGeometry
                .buildScanWindow(
              screenSize: layoutSize,
              orientation: orientation,
            );

            assert(() {
              debugPrint(
                'QR scanWindow normalized: '
                    '$scanWindowNormalized '
                    '(layoutSize: $layoutSize)',
              );
              return true;
            }());

            return MobileScanner(
              controller:
              widget.scannerController,
              fit: BoxFit.cover,
              tapToFocus: true,

              scanWindow: scanWindowNormalized,

              // A small non-zero threshold avoids reconfiguring the
              // native scan region on every micro-rebuild.
              scanWindowUpdateThreshold: 0.05,

              onDetect: _handleCapture,

              onDetectError: (
                  Object error,
                  StackTrace stackTrace,
                  ) {
                debugPrint(
                  'Mobile scanner detection error: '
                      '$error',
                );
              },

              placeholderBuilder: (
                  BuildContext context,
                  ) {
                return QrCameraLoadingView();
              },

              errorBuilder: (
                  BuildContext context,
                  MobileScannerException error,
                  ) {
                debugPrint(
                  'Mobile scanner camera error: '
                      '${error.errorCode}',
                );

                return QrCameraErrorView(
                  onRetry: widget.onRetry,
                );
              },

              overlayBuilder: (
                  BuildContext context,
                  BoxConstraints constraints,
                  ) {
                return QrScannerOverlay(
                  scanWindow: scanWindowPixels,
                  scannerController:
                  widget
                      .scannerController,
                  frameColor:
                  colorScheme.primary,
                );
              },
            );
          },
        );
      },
    );
  }
}