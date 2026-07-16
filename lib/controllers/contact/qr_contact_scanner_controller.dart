import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrContactScannerController extends GetxController with WidgetsBindingObserver {
  final MobileScannerController scannerController = MobileScannerController(
    autoStart: true,
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates,
    detectionTimeoutMs: 500,
    formats: [
      BarcodeFormat.qrCode,
    ],
  );

  final RxBool isProcessing = false.obs;
  final RxBool isTorchOn = false.obs;
  final RxBool isSwitchingCamera = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Register lifecycle observer to manage camera resources
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    // Unregister observer and dispose scanner
    WidgetsBinding.instance.removeObserver(this);
    unawaited(scannerController.dispose());
    super.onClose();
  }

  // UX Improvement: Safely handle instances when the app goes into the background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      unawaited(scannerController.stop());
    } else if (state == AppLifecycleState.resumed) {
      unawaited(scannerController.start());
    }
  }

  Future<void> handleDetect(BarcodeCapture capture) async {
    if (isProcessing.value) {
      return;
    }

    String scannedValue = '';

    for (Barcode barcode in capture.barcodes) {
      String value = barcode.rawValue?.trim() ?? '';

      if (value.isNotEmpty) {
        scannedValue = value;
        break;
      }
    }

    if (scannedValue.isEmpty) {
      return;
    }

    isProcessing.value = true;
    errorMessage.value = '';

    await HapticFeedback.mediumImpact();

    try {
      await scannerController.stop();
    } catch (_) {}

    Get.back<String>(
      result: scannedValue,
    );
  }

  Future<void> toggleTorch() async {
    try {
      await scannerController.toggleTorch();
      isTorchOn.toggle();
      errorMessage.value = '';
    } catch (_) {
      errorMessage.value = 'Flashlight is not available on this device';
    }
  }

  Future<void> switchCamera() async {
    if (isSwitchingCamera.value) {
      return;
    }

    isSwitchingCamera.value = true;

    try {
      await scannerController.switchCamera();
      errorMessage.value = '';
    } catch (_) {
      errorMessage.value = 'Unable to switch the camera';
    } finally {
      isSwitchingCamera.value = false;
    }
  }

  Future<void> restartScanner() async {
    isProcessing.value = false;
    errorMessage.value = '';

    try {
      await scannerController.start();
    } catch (_) {
      errorMessage.value = 'Unable to start the camera';
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  void closeScanner() {
    Get.back<String>();
  }
}