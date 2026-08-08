import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'qr_scanner_auto_zoom.dart';
import 'qr_scanner_feedback.dart';
import 'qr_scanner_geometry.dart' as scanner_geometry;
import 'qr_scanner_overlay.dart';

/// UPDATED: Unit UI QR scanner camera view wrapping MobileScanner with auto-zoom, geometry calculations, and overlay
class QrScannerCameraView extends StatefulWidget {
  final MobileScannerController scannerController;

  final void Function(
      BarcodeCapture capture,
      ) onDetect;

  final VoidCallback onRetry;

  const QrScannerCameraView({
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

class _QrScannerCameraViewState extends State<QrScannerCameraView> {
  late QrScannerAutoZoom _autoZoomController;

  // UPDATED: Guard flag preventing concurrent duplicate barcode processing
  bool _isHandlingCapture = false;

  @override
  void initState() {
    super.initState();

    // UPDATED: Initialize auto-zoom helper with active mobile scanner controller
    _autoZoomController = QrScannerAutoZoom(
      controller: widget.scannerController,
    );
  }

  @override
  void didUpdateWidget(
      QrScannerCameraView oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    // UPDATED: Rebind auto-zoom helper if camera controller instance updates
    if (oldWidget.scannerController != widget.scannerController) {
      _autoZoomController = QrScannerAutoZoom(
        controller: widget.scannerController,
      );
    }
  }

  /// UPDATED: Captures barcode scan events and prevents duplicate concurrent handlers
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

  /// UPDATED: Prepares barcode capture using auto-zoom controller before passing to onDetect
  Future<void> _prepareCapture(
      BarcodeCapture capture,
      ) async {
    try {
      bool shouldProcess = await _autoZoomController.prepareCapture(
        capture,
      );

      if (!mounted || !shouldProcess) {
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
    // UPDATED: Access colorScheme for theme-aware scanner overlay framing
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;

            // UPDATED: Render camera loading view if layout bounds are non-finite or invalid
            if (!width.isFinite ||
                !height.isFinite ||
                width <= 0 ||
                height <= 0) {
              return const QrCameraLoadingView();
            }

            Size layoutSize = Size(
              width,
              height,
            );

            // UPDATED: Calculates pixel-space rectangle for screen overlay frame drawing
            Rect scanWindowPixels =
            scanner_geometry.QrScannerGeometry.buildScanWindowPixels(
              screenSize: layoutSize,
              orientation: orientation,
            );

            // UPDATED: Calculates normalized (0.0 - 1.0) rect required by MobileScanner detection window
            Rect scanWindowNormalized =
            scanner_geometry.QrScannerGeometry.buildScanWindow(
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

            // UPDATED: MobileScanner camera view with tap-to-focus, scanWindow, and custom overlay
            return MobileScanner(
              controller: widget.scannerController,
              fit: BoxFit.cover,
              tapToFocus: true,
              scanWindow: scanWindowNormalized,
              scanWindowUpdateThreshold: 0.05,
              onDetect: _handleCapture,
              onDetectError: (
                  Object error,
                  StackTrace stackTrace,
                  ) {
                debugPrint(
                  'Mobile scanner detection error: $error',
                );
              },
              placeholderBuilder: (
                  BuildContext context,
                  ) {
                return const QrCameraLoadingView();
              },
              errorBuilder: (
                  BuildContext context,
                  MobileScannerException error,
                  ) {
                debugPrint(
                  'Mobile scanner camera error: ${error.errorCode}',
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
                  scannerController: widget.scannerController,
                  frameColor: colorScheme.primary,
                );
              },
            );
          },
        );
      },
    );
  }
}