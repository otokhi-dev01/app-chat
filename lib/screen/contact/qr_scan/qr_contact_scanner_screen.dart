// import 'package:appchat/screen/contact/qr_scan/qr_scanner_app_bar.dart';
// import 'package:appchat/screen/contact/qr_scan/qr_scanner_bottom_panel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/contact/qr_contact_scanner_controller.dart';
// import '../../profile/qr_scanner/qr_sanner_camera_view.dart';
// import '../../profile/qr_scanner/qr_scanner_feedback.dart';
//
// class QrContactScannerScreen extends GetView<QrContactScannerController> {
//   const QrContactScannerScreen({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     ColorScheme colorScheme = Theme.of(context).colorScheme;
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light.copyWith(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.dark,
//         systemNavigationBarColor: Colors.black,
//         systemNavigationBarIconBrightness: Brightness.light,
//         systemNavigationBarDividerColor: Colors.transparent,
//         systemNavigationBarContrastEnforced: false,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         extendBodyBehindAppBar: true,
//         appBar: QrScannerAppBar(
//           onBack: controller.closeScanner,
//         ),
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             QrScannerCameraView(
//               scannerController: controller.scannerController,
//               onDetect: controller.handleDetect,
//               onRetry: controller.restartScanner,
//             ),
//             Positioned(
//               top: 84,
//               left: 16,
//               right: 16,
//               child: SafeArea(
//                 bottom: false,
//                 child: Obx(
//                       () {
//                     String message = controller.errorMessage.value;
//
//                     if (message.isEmpty) {
//                       return SizedBox.shrink();
//                     }
//
//                     return QrScannerMessage(
//                       message: message,
//                       onClose: controller.clearError,
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 16,
//               right: 16,
//               bottom: 18,
//               child: SafeArea(
//                 top: false,
//                 child: QrScannerBottomPanel(
//                   controller: controller,
//                 ),
//               ),
//             ),
//             Obx(
//                   () {
//                 if (!controller.isProcessing.value) {
//                   return SizedBox.shrink();
//                 }
//
//                 return QrScannerProcessingView(
//                   color: colorScheme.primary,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../controllers/contact/qr_contact_scanner_controller.dart';

/// UPDATED: QrContactScannerScreen with intelligent auto-zoom for far QR codes (compatible with mobile_scanner 7.4.0)
class QrContactScannerScreen extends StatefulWidget {
  const QrContactScannerScreen({super.key});

  @override
  State<QrContactScannerScreen> createState() => _QrContactScannerScreenState();
}

class _QrContactScannerScreenState extends State<QrContactScannerScreen> {
  late final QrContactScannerController controller;

  // ADDED: Guard flags to throttle auto-zoom updates and track camera zoom scale
  bool _isAutoZooming = false;
  DateTime _lastAutoZoomTime = DateTime.now();

  // FIXED: Track current zoom scale factor locally (0.0 to 1.0) for mobile_scanner 7.4.0
  double _currentZoomScale = 0.0;

  @override
  void initState() {
    super.initState();
    controller = Get.find<QrContactScannerController>();
  }

  /// ADDED: Detects far QR codes and automatically adjusts camera zoom scale
  void _handleDetectWithAutoZoom(BarcodeCapture capture) {
    if (controller.isProcessing.value) return;

    _checkAndAutoZoom(capture);
    controller.handleDetect(capture);
  }

  /// ADDED: Calculates QR size from barcode.corners and auto-zooms if QR code is small/far away
  void _checkAndAutoZoom(BarcodeCapture capture) {
    if (_isAutoZooming) return;

    // Throttle auto-zoom calculations to once every 600ms for smooth camera transitions
    final DateTime now = DateTime.now();
    if (now.difference(_lastAutoZoomTime).inMilliseconds < 600) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    for (final Barcode barcode in barcodes) {
      // FIXED: Replaced non-existent boundingBox with barcode.corners (List<Offset>) for mobile_scanner 7.4.0
      final List<Offset> corners = barcode.corners;
      if (corners.length < 2) continue;

      final Size size = MediaQuery.of(context).size;
      final double scanSize = size.width * 0.7;

      // FIXED: Calculate QR code width from top-left (corners[0]) and top-right (corners[1])
      final double qrWidth = (corners[1].dx - corners[0].dx).abs();

      // FIXED: If QR code width is small (< 35% of scan frame), auto-zoom camera in
      if (qrWidth > 0 && qrWidth < scanSize * 0.35) {
        _isAutoZooming = true;
        _lastAutoZoomTime = DateTime.now();

        try {
          // FIXED: Increment current zoom scale factor and pass to setZoomScale
          _currentZoomScale = (_currentZoomScale + 0.30).clamp(0.0, 1.0);
          controller.scannerController.setZoomScale(_currentZoomScale);
        } catch (e) {
          debugPrint('Auto-zoom error: $e');
        } finally {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) _isAutoZooming = false;
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.black.withValues(alpha: 0.60);

    Color actionBackground =
    isDark ? const Color(0xFF1B1D22) : Colors.black54;

    return Scaffold(
      backgroundColor: Colors.black,
      // UPDATED: Glassmorphism translucent AppBar with 40x40 circular action buttons
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: appBarColor,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: actionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: controller.closeScanner,
              child: const Icon(
                CupertinoIcons.xmark,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          // Torch Toggle Button
          Obx(
                () => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: actionBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: controller.toggleTorch,
                  child: Icon(
                    controller.isTorchOn.value
                        ? CupertinoIcons.bolt_fill
                        : CupertinoIcons.bolt_slash,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // Camera Rotate Switch Button
          Obx(
                () => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: actionBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: controller.switchCamera,
                  child: controller.isSwitchingCamera.value
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    CupertinoIcons.camera_rotate,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Camera Preview with Intelligent Auto-Zoom Detection
          MobileScanner(
            controller: controller.scannerController,
            onDetect: _handleDetectWithAutoZoom,
          ),

          // 2. Cut-out Scan Window Overlay
          _ScannerOverlay(primaryColor: colorScheme.primary),

          // 3. Processing Indicator Overlay
          Obx(
                () => controller.isProcessing.value
                ? Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
                : const SizedBox.shrink(),
          ),

          // 4. Error Message + Retry Dialog
          Obx(
                () {
              if (controller.errorMessage.value.isEmpty) {
                return const SizedBox.shrink();
              }

              return Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1D22),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: controller.restartScanner,
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 5. Instruction Hint Text
          const Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Text(
              'Align the QR code within the frame\nAuto-zooms for far QR codes',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// ADDED: Scanner overlay with primary corner accents and glow scan window frame
class _ScannerOverlay extends StatelessWidget {
  final Color primaryColor;

  const _ScannerOverlay({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double scanSize = constraints.maxWidth * 0.7;

          return Stack(
            children: [
              Center(
                child: Container(
                  width: scanSize,
                  height: scanSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 2.5),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.25),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}