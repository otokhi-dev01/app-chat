import 'package:appchat/screen/contact/qr_scan/qr_scanner_app_bar.dart';
import 'package:appchat/screen/contact/qr_scan/qr_scanner_bottom_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/contact/qr_contact_scanner_controller.dart';
import '../../widgets/qr_code/qr_sanner_camera_view.dart';
import '../../widgets/qr_code/qr_scanner_feedback.dart';

class QrContactScannerScreen
    extends GetView<QrContactScannerController> {
  QrContactScannerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        Brightness.light,
        statusBarBrightness:
        Brightness.dark,
        systemNavigationBarColor:
        Colors.black,
        systemNavigationBarIconBrightness:
        Brightness.light,
        systemNavigationBarDividerColor:
        Colors.transparent,
        systemNavigationBarContrastEnforced:
        false,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: QrScannerAppBar(
          onBack: controller.closeScanner,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            QrScannerCameraView(
              scannerController:
              controller.scannerController,
              onDetect:
              controller.handleDetect,
              onRetry:
              controller.restartScanner,
            ),

            Positioned(
              top: 84,
              left: 16,
              right: 16,
              child: SafeArea(
                bottom: false,
                child: Obx(
                      () {
                    String message =
                        controller
                            .errorMessage.value;

                    if (message.isEmpty) {
                      return SizedBox.shrink();
                    }

                    return QrScannerMessage(
                      message: message,
                      onClose:
                      controller.clearError,
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
                child: QrScannerBottomPanel(
                  controller: controller,
                ),
              ),
            ),

            Obx(
                  () {
                if (!controller
                    .isProcessing.value) {
                  return SizedBox.shrink();
                }

                return QrScannerProcessingView(
                  color:
                  colorScheme.primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}