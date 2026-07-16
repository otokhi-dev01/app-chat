import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../controllers/contact/qr_contact_scanner_controller.dart';

class QrContactScannerScreen extends StatelessWidget {
  QrContactScannerScreen({
    super.key,
  });

  // Inject the controller here so that it initializes automatically on load
  final QrContactScannerController controller = Get.put(QrContactScannerController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(
          context: context,
          theme: theme,
          colorScheme: colorScheme,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: controller.scannerController,
              fit: BoxFit.cover,
              tapToFocus: true,
              onDetect: controller.handleDetect,
              placeholderBuilder: (BuildContext context) {
                return _CameraLoadingView();
              },
              // Fixed: Removed the third parameter to match the mobile_scanner 7.x signature
              errorBuilder: (BuildContext context, MobileScannerException error) {
                return _CameraErrorView(
                  onRetry: controller.restartScanner,
                );
              },
            ),

            IgnorePointer(
              child: CustomPaint(
                painter: _QrScannerOverlayPainter(
                  overlayColor: Colors.black.withValues(
                    alpha: 0.58,
                  ),
                  frameColor: colorScheme.primary,
                ),
              ),
            ),

            Positioned(
              top: 84,
              left: 16,
              right: 16,
              child: SafeArea(
                bottom: false,
                child: Obx(
                      () {
                    String message = controller.errorMessage.value;

                    if (message.isEmpty) {
                      return SizedBox.shrink();
                    }

                    return _ScannerMessage(
                      message: message,
                      onClose: controller.clearError,
                    );
                  },
                ),
              ),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: SafeArea(
                top: false,
                child: _ScannerBottomPanel(
                  controller: controller,
                ),
              ),
            ),

            Obx(
                  () {
                if (!controller.isProcessing.value) {
                  return SizedBox.shrink();
                }

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
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return AppBar(
      toolbarHeight: 68,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 60,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.38,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.10,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(
          left: 10,
          top: 12,
          bottom: 12,
        ),
        child: _ScannerCircleButton(
          tooltip: 'Back',
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: controller.closeScanner,
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan QR code',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Scan a contact QR code',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(
                alpha: 0.72,
              ),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            top: 12,
            bottom: 12,
            right: 10,
          ),
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.18,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(
                  alpha: 0.35,
                ),
              ),
            ),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              color: colorScheme.primary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScannerBottomPanel extends StatelessWidget {
  final QrContactScannerController controller;

  const _ScannerBottomPanel({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1B1D22).withValues(
              alpha: 0.90,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.28,
                ),
                blurRadius: 26,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(
                        alpha: 0.14,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.center_focus_strong_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Place the QR code in the frame',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'The camera scans automatically',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(
                              alpha: 0.65,
                            ),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                          () {
                        bool isTorchOn = controller.isTorchOn.value;

                        return _ScannerControlButton(
                          icon: isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                          label: isTorchOn ? 'Flash on' : 'Flash off',
                          isActive: isTorchOn,
                          onTap: controller.toggleTorch,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                          () {
                        bool isSwitching = controller.isSwitchingCamera.value;

                        return _ScannerControlButton(
                          icon: Icons.cameraswitch_rounded,
                          label: isSwitching ? 'Switching...' : 'Flip camera',
                          isActive: false,
                          isLoading: isSwitching,
                          onTap: controller.switchCamera,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;

  const _ScannerControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor = isActive
        ? colorScheme.primary
        : Colors.white.withValues(
      alpha: 0.08,
    );

    Color foregroundColor = isActive ? colorScheme.onPrimary : Colors.white;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? colorScheme.primary
                  : Colors.white.withValues(
                alpha: 0.08,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor,
                  ),
                )
              else
                Icon(
                  icon,
                  color: foregroundColor,
                  size: 20,
                ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

class _ScannerCircleButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _ScannerCircleButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(
          alpha: 0.34,
        ),
        shape: CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: CircleBorder(),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannerMessage extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const _ScannerMessage({
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.error,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 10, 8, 10),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
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
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.onError,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraLoadingView extends StatelessWidget {
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

class _CameraErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _CameraErrorView({
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
              Icons.no_photography_outlined,
              color: colorScheme.error,
              size: 34,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Camera unavailable',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Check camera permission and try again.',
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
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                child: Text(
                  'Try again',
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

class _QrScannerOverlayPainter extends CustomPainter {
  final Color overlayColor;
  final Color frameColor;

  _QrScannerOverlayPainter({
    required this.overlayColor,
    required this.frameColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double availableWidth = size.width - 48;

    double scannerSize = availableWidth > 290 ? 290 : availableWidth;

    Rect scannerRect = Rect.fromCenter(
      center: Offset(
        size.width / 2,
        size.height * 0.42,
      ),
      width: scannerSize,
      height: scannerSize,
    );

    RRect scannerRRect = RRect.fromRectAndRadius(
      scannerRect,
      Radius.circular(28),
    );

    Path fullPath = Path()
      ..addRect(
        Offset.zero & size,
      );

    Path scannerPath = Path()..addRRect(scannerRRect);

    Path darkArea = Path.combine(
      PathOperation.difference,
      fullPath,
      scannerPath,
    );

    Paint overlayPaint = Paint()..color = overlayColor;

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

    Paint cornerPaint = Paint()
      ..color = frameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    double cornerLength = 32;
    double inset = 3;

    double left = scannerRect.left + inset;
    double right = scannerRect.right - inset;
    double top = scannerRect.top + inset;
    double bottom = scannerRect.bottom - inset;

    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top + 8),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + 8, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(right - cornerLength, top),
      Offset(right - 8, top),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(right, top + 8),
      Offset(right, top + cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left, bottom - cornerLength),
      Offset(left, bottom - 8),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + 8, bottom),
      Offset(left + cornerLength, bottom),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(right - cornerLength, bottom),
      Offset(right - 8, bottom),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(right, bottom - cornerLength),
      Offset(right, bottom - 8),
      cornerPaint,
    );

    Paint scanLinePaint = Paint()
      ..color = frameColor.withValues(
        alpha: 0.65,
      )
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(
        scannerRect.left + 28,
        scannerRect.center.dy,
      ),
      Offset(
        scannerRect.right - 28,
        scannerRect.center.dy,
      ),
      scanLinePaint,
    );
  }

  @override
  bool shouldRepaint(_QrScannerOverlayPainter oldDelegate) {
    return oldDelegate.overlayColor != overlayColor || oldDelegate.frameColor != frameColor;
  }
}