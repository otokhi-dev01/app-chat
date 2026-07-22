import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerAutoZoom {
  final MobileScannerController controller;

  final Duration zoomInterval;
  final double minimumAcceptedCoverage;
  final double maximumZoom;
  final double zoomStep;

  DateTime? _lastZoomTime;
  bool _isUpdatingZoom = false;

  QrScannerAutoZoom({
    required this.controller,
    Duration? zoomInterval,
    this.minimumAcceptedCoverage = 0.22,
    this.maximumZoom = 0.82,
    this.zoomStep = 0.13,
  }) : zoomInterval =
      zoomInterval ??
          Duration(
            milliseconds: 320,
          );

  bool get _needsManualAutoZoom {
    return defaultTargetPlatform ==
        TargetPlatform.iOS ||
        defaultTargetPlatform ==
            TargetPlatform.macOS;
  }

  Future<bool> prepareCapture(
      BarcodeCapture capture,
      ) async {
    if (!_needsManualAutoZoom) {
      return true;
    }

    if (_isUpdatingZoom) {
      return false;
    }

    Barcode? qrCode =
    _findTrackableQrCode(
      capture,
    );

    if (qrCode == null ||
        capture.size.isEmpty) {
      return true;
    }

    double coverage =
    _calculateCoverage(
      barcode: qrCode,
      cameraSize: capture.size,
    );

    if (coverage >=
        minimumAcceptedCoverage) {
      return true;
    }

    double currentZoom =
        controller.value.zoomScale;

    if (currentZoom >= maximumZoom) {
      return true;
    }

    DateTime now = DateTime.now();

    if (_lastZoomTime != null &&
        now.difference(_lastZoomTime!) <
            zoomInterval) {
      return false;
    }

    _lastZoomTime = now;
    _isUpdatingZoom = true;

    try {
      double extraZoom =
      _calculateZoomStep(
        coverage,
      );

      double nextZoom =
      (currentZoom + extraZoom)
          .clamp(
        0.0,
        maximumZoom,
      )
          .toDouble();

      await controller.setZoomScale(
        nextZoom,
      );

      return false;
    } catch (error) {
      debugPrint(
        'QR auto zoom failed: $error',
      );

      return true;
    } finally {
      _isUpdatingZoom = false;
    }
  }

  Barcode? _findTrackableQrCode(
      BarcodeCapture capture,
      ) {
    for (Barcode barcode
    in capture.barcodes) {
      bool isQr =
          barcode.format ==
              BarcodeFormat.qrCode;

      bool hasCorners =
          barcode.corners.length >= 4;

      if (isQr && hasCorners) {
        return barcode;
      }
    }

    return null;
  }

  double _calculateCoverage({
    required Barcode barcode,
    required Size cameraSize,
  }) {
    Rect bounds =
    _buildBarcodeBounds(
      barcode.corners,
    );

    double widthCoverage =
        bounds.width / cameraSize.width;

    double heightCoverage =
        bounds.height / cameraSize.height;

    return widthCoverage > heightCoverage
        ? widthCoverage
        : heightCoverage;
  }

  Rect _buildBarcodeBounds(
      List<Offset> corners,
      ) {
    double left = corners.first.dx;
    double right = corners.first.dx;
    double top = corners.first.dy;
    double bottom = corners.first.dy;

    for (Offset point in corners.skip(1)) {
      if (point.dx < left) {
        left = point.dx;
      }

      if (point.dx > right) {
        right = point.dx;
      }

      if (point.dy < top) {
        top = point.dy;
      }

      if (point.dy > bottom) {
        bottom = point.dy;
      }
    }

    return Rect.fromLTRB(
      left,
      top,
      right,
      bottom,
    );
  }

  double _calculateZoomStep(
      double coverage,
      ) {
    if (coverage < 0.08) {
      return zoomStep * 1.65;
    }

    if (coverage < 0.14) {
      return zoomStep * 1.30;
    }

    return zoomStep;
  }

  Future<void> reset() async {
    _lastZoomTime = null;
    _isUpdatingZoom = false;

    try {
      await controller.resetZoomScale();
    } catch (error) {
      debugPrint(
        'Unable to reset QR zoom: $error',
      );
    }
  }
}