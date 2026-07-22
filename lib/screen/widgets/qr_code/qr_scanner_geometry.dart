import 'dart:math' as math;

import 'package:flutter/material.dart';

class QrScannerGeometry {
  /// Pixel-space rect, matching the screen's own coordinate system.
  /// Use this for drawing the visible overlay frame.
  static Rect buildScanWindowPixels({
    required Size screenSize,
    required Orientation orientation,
  }) {
    return orientation == Orientation.landscape
        ? _buildLandscapePixelWindow(
      screenSize,
    )
        : _buildPortraitPixelWindow(
      screenSize,
    );
  }

  /// Returns a scan window in NORMALIZED coordinates (0.0 - 1.0),
  /// relative to the camera preview — this is what mobile_scanner's
  /// `scanWindow` parameter requires. It is NOT raw screen pixels.
  static Rect buildScanWindow({
    required Size screenSize,
    required Orientation orientation,
  }) {
    Rect pixelRect = buildScanWindowPixels(
      screenSize: screenSize,
      orientation: orientation,
    );

    return _normalize(
      pixelRect,
      screenSize,
    );
  }

  static Rect _normalize(
      Rect pixelRect,
      Size screenSize,
      ) {
    if (screenSize.width <= 0 ||
        screenSize.height <= 0) {
      return Rect.fromLTWH(
        0,
        0,
        1,
        1,
      );
    }

    double left =
        pixelRect.left / screenSize.width;

    double top =
        pixelRect.top / screenSize.height;

    double right =
        pixelRect.right / screenSize.width;

    double bottom =
        pixelRect.bottom / screenSize.height;

    // Clamp every edge into [0, 1] — mobile_scanner throws if the
    // window falls even slightly outside the normalized bounds,
    // which can otherwise happen near screen edges or during
    // rotation transitions.
    left = left.clamp(0.0, 1.0);
    top = top.clamp(0.0, 1.0);
    right = right.clamp(0.0, 1.0);
    bottom = bottom.clamp(0.0, 1.0);

    if (right <= left || bottom <= top) {
      return Rect.fromLTWH(
        0,
        0,
        1,
        1,
      );
    }

    return Rect.fromLTRB(
      left,
      top,
      right,
      bottom,
    );
  }

  static Rect _buildPortraitPixelWindow(
      Size screenSize,
      ) {
    double availableWidth =
        screenSize.width - 48;

    double availableHeight =
        screenSize.height * 0.40;

    double scannerSize = math.min(
      availableWidth,
      availableHeight,
    );

    scannerSize = scannerSize
        .clamp(
      220.0,
      300.0,
    )
        .toDouble();

    return Rect.fromCenter(
      center: Offset(
        screenSize.width / 2,
        screenSize.height * 0.42,
      ),
      width: scannerSize,
      height: scannerSize,
    );
  }

  static Rect _buildLandscapePixelWindow(
      Size screenSize,
      ) {
    double availableHeight =
        screenSize.height - 150;

    double availableWidth =
        screenSize.width * 0.42;

    double scannerSize = math.min(
      availableHeight,
      availableWidth,
    );

    scannerSize = scannerSize
        .clamp(
      180.0,
      280.0,
    )
        .toDouble();

    return Rect.fromCenter(
      center: Offset(
        screenSize.width / 2,
        screenSize.height / 2,
      ),
      width: scannerSize,
      height: scannerSize,
    );
  }
}