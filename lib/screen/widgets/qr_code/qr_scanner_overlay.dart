import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerGeometry {
  static Rect buildScanWindow(
      Size screenSize,
      ) {
    double availableWidth =
        screenSize.width - 48;

    double scannerSize =
    availableWidth.clamp(
      220,
      290,
    );

    return Rect.fromCenter(
      center: Offset(
        screenSize.width / 2,
        screenSize.height * 0.42,
      ),
      width: scannerSize,
      height: scannerSize,
    );
  }
}

class QrScannerOverlay
    extends StatelessWidget {
  final Rect scanWindow;

  final MobileScannerController
  scannerController;

  final Color frameColor;

  QrScannerOverlay({
    super.key,
    required this.scanWindow,
    required this.scannerController,
    required this.frameColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: QrScannerCropPainter(
            scanWindow: scanWindow,
            overlayColor:
            Colors.black.withValues(
              alpha: 0.58,
            ),
            frameColor: frameColor,
          ),
        ),

        QrTrackedCodeOverlay(
          controller: scannerController,
          color: frameColor,
        ),
      ],
    );
  }
}

class QrTrackedCodeOverlay
    extends StatefulWidget {
  final MobileScannerController controller;
  final Color color;

  QrTrackedCodeOverlay({
    super.key,
    required this.controller,
    required this.color,
  });

  @override
  State<QrTrackedCodeOverlay> createState() {
    return _QrTrackedCodeOverlayState();
  }
}

class _QrTrackedCodeOverlayState
    extends State<QrTrackedCodeOverlay> {
  final TextPainter _textPainter =
  TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  @override
  void dispose() {
    _textPainter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<
        MobileScannerState>(
      valueListenable: widget.controller,
      builder: (
          BuildContext context,
          MobileScannerState scannerState,
          Widget? child,
          ) {
        bool scannerReady =
            scannerState.isInitialized &&
                scannerState.isRunning &&
                scannerState.error == null;

        if (!scannerReady) {
          return SizedBox.shrink();
        }

        return StreamBuilder<BarcodeCapture>(
          key: ValueKey<DeviceOrientation>(
            scannerState.deviceOrientation,
          ),
          stream:
          widget.controller.barcodes,
          builder: (
              BuildContext context,
              AsyncSnapshot<BarcodeCapture>
              snapshot,
              ) {
            BarcodeCapture? capture =
                snapshot.data;

            if (capture == null ||
                capture.size.isEmpty ||
                capture.barcodes.isEmpty) {
              return SizedBox.shrink();
            }

            List<Barcode> qrCodes =
            capture.barcodes.where(
                  (Barcode barcode) {
                return barcode.format ==
                    BarcodeFormat.qrCode &&
                    barcode.corners.length >=
                        4 &&
                    !barcode.size.isEmpty;
              },
            ).toList(
              growable: false,
            );

            if (qrCodes.isEmpty) {
              return SizedBox.shrink();
            }

            return Stack(
              fit: StackFit.expand,
              children: qrCodes.map(
                    (Barcode barcode) {
                  return CustomPaint(
                    painter: BarcodePainter(
                      barcodeCorners:
                      barcode.corners,
                      barcodeSize:
                      barcode.size,

                      // Empty so the raw QR value
                      // is not displayed over the code.
                      barcodeValue: '',

                      boxFit: BoxFit.cover,
                      cameraPreviewSize:
                      capture.size,
                      color: widget.color,
                      style:
                      PaintingStyle.stroke,
                      strokeWidth: 4,
                      textPainter:
                      _textPainter,
                      deviceOrientation:
                      scannerState
                          .deviceOrientation,
                    ),
                  );
                },
              ).toList(
                growable: false,
              ),
            );
          },
        );
      },
    );
  }
}

class QrScannerCropPainter
    extends CustomPainter {
  final Rect scanWindow;
  final Color overlayColor;
  final Color frameColor;

  QrScannerCropPainter({
    required this.scanWindow,
    required this.overlayColor,
    required this.frameColor,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    RRect scannerRRect =
    RRect.fromRectAndRadius(
      scanWindow,
      Radius.circular(28),
    );

    Path fullPath = Path()
      ..addRect(
        Offset.zero & size,
      );

    Path scannerPath = Path()
      ..addRRect(
        scannerRRect,
      );

    Path darkArea = Path.combine(
      PathOperation.difference,
      fullPath,
      scannerPath,
    );

    Paint overlayPaint = Paint()
      ..color = overlayColor;

    canvas.drawPath(
      darkArea,
      overlayPaint,
    );

    Paint softBorderPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: 0.22,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawRRect(
      scannerRRect,
      softBorderPaint,
    );

    _drawCorners(
      canvas: canvas,
      rect: scanWindow,
    );

    Paint scanLinePaint = Paint()
      ..color = frameColor.withValues(
        alpha: 0.60,
      )
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(
        scanWindow.left + 28,
        scanWindow.center.dy,
      ),
      Offset(
        scanWindow.right - 28,
        scanWindow.center.dy,
      ),
      scanLinePaint,
    );
  }

  void _drawCorners({
    required Canvas canvas,
    required Rect rect,
  }) {
    Paint cornerPaint = Paint()
      ..color = frameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    double cornerLength = 32;
    double inset = 3;
    double smallGap = 8;

    double left =
        rect.left + inset;

    double right =
        rect.right - inset;

    double top =
        rect.top + inset;

    double bottom =
        rect.bottom - inset;

    canvas.drawLine(
      Offset(
        left,
        top + cornerLength,
      ),
      Offset(
        left,
        top + smallGap,
      ),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(
        left + smallGap,
        top,
      ),
      Offset(
        left + cornerLength,
        top,
      ),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(
        right - cornerLength,
        top,
      ),
      Offset(
        right - smallGap,
        top,
      ),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(
        right,
        top + smallGap,
      ),
      Offset(
        right,
        top + cornerLength,
      ),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(
        left,
        bottom - cornerLength,
      ),
      Offset(
        left,
        bottom - smallGap,
      ),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(
        left + smallGap,
        bottom,
      ),
      Offset(
        left + cornerLength,
        bottom,
      ),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(
        right - cornerLength,
        bottom,
      ),
      Offset(
        right - smallGap,
        bottom,
      ),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(
        right,
        bottom - cornerLength,
      ),
      Offset(
        right,
        bottom - smallGap,
      ),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(
      QrScannerCropPainter oldDelegate,
      ) {
    return oldDelegate.scanWindow !=
        scanWindow ||
        oldDelegate.overlayColor !=
            overlayColor ||
        oldDelegate.frameColor !=
            frameColor;
  }
}