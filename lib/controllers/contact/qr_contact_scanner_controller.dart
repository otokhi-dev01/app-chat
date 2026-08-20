import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../models/contact_model.dart';
import '../../models/user_model.dart';
import '../../services/contact_service/contact_api_service.dart';
import '../../services/user_service/user_service.dart';

class QrContactScannerController extends GetxController with WidgetsBindingObserver {
  final UserApiService appUserService;
  final ContactApiService contactService;

  QrContactScannerController({
    required this.appUserService,
    required this.contactService,
  });

  final MobileScannerController scannerController =
  MobileScannerController(
    autoStart: true,
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 500,
    formats: const [
      BarcodeFormat.qrCode,
    ],
  );

  final RxBool isProcessing = false.obs;
  final RxBool isTorchOn = false.obs;
  final RxBool isSwitchingCamera = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString scannedValue = ''.obs;

  bool _isClosed = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    if (_isClosed) {
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(_stopScanner());
      return;
    }

    if (state == AppLifecycleState.resumed && !isProcessing.value) {
      unawaited(_startScanner());
    }
  }

  Future<void> handleDetect(
      BarcodeCapture capture,
      ) async {
    if (isProcessing.value || _isClosed) {
      return;
    }

    String rawValue = _getBarcodeValue(capture);

    if (rawValue.isEmpty) {
      return;
    }

    isProcessing.value = true;
    scannedValue.value = rawValue;
    errorMessage.value = '';

    await HapticFeedback.mediumImpact();
    await _stopScanner();

    try {
      String userValue = _extractUserValue(rawValue);

      if (userValue.isEmpty) {
        throw StateError(
          'This QR code does not contain a valid user.',
        );
      }

      AppUserModel? user = await _findUser(userValue);

      if (user == null) {
        throw StateError(
          'User not found.',
        );
      }

      AppUserModel? currentUser = await appUserService.getCurrentUser();

      if (currentUser?.id == user.id) {
        throw StateError(
          'You cannot add yourself as a contact.',
        );
      }

      ContactModel? contact = await contactService.createContact(
        contactUserId: user.id,
      );

      if (contact == null) {
        throw StateError(
          'Unable to add this user to contacts.',
        );
      }

      if (_isClosed) {
        return;
      }

      Get.back<ContactModel>(
        result: contact,
      );
    } catch (error) {
      isProcessing.value = false;
      errorMessage.value = _cleanErrorMessage(error);

      await _startScanner();
    }
  }

  String _getBarcodeValue(
      BarcodeCapture capture,
      ) {
    for (Barcode barcode in capture.barcodes) {
      String value = barcode.rawValue?.trim() ?? '';

      if (value.isNotEmpty) {
        return value;
      }
    }

    return '';
  }

  String _extractUserValue(
      String rawValue,
      ) {
    String value = rawValue.trim();

    if (value.isEmpty) {
      return '';
    }

    if (value.startsWith('user:')) {
      return value.substring('user:'.length).trim();
    }

    Uri? uri = Uri.tryParse(value);

    if (uri != null && uri.scheme == 'appchat') {
      List<String> segments = uri.pathSegments.where(
            (String segment) {
          return segment.trim().isNotEmpty;
        },
      ).toList();

      if (uri.host == 'user' && segments.isNotEmpty) {
        return segments.first.trim();
      }

      if (segments.length >= 2 && segments.first == 'user') {
        return segments[1].trim();
      }
    }

    return value;
  }

  Future<AppUserModel?> _findUser(String value) async {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return null;
    }

    // First, treat the QR value as a user ID.
    try {
      return await appUserService.getUserById(cleanValue);
    } catch (error) {
      debugPrint('User ID lookup failed: $error');
    }

    // If it is not an ID, search by username or phone number.
    try {
      final results = await appUserService.searchUsers(
        query: cleanValue,
      );

      if (results.isEmpty) {
        return null;
      }

      final normalizedValue = _normalizeValue(cleanValue);
      final normalizedPhone = _normalizePhoneNumber(cleanValue);

      for (final item in results) {
        final matchesId =
            _normalizeValue(item.id) == normalizedValue;

        final matchesUsername =
            _normalizeValue(item.username) == normalizedValue;

        final matchesPhone =
            _normalizePhoneNumber(item.phoneNumber) ==
                normalizedPhone;

        if (matchesId || matchesUsername || matchesPhone) {
          return item;
        }
      }

      return null;
    } catch (error) {
      debugPrint('User search failed: $error');
      return null;
    }
  }

  String _normalizeValue(
      String value,
      ) {
    return value.trim().replaceFirst('@', '').toLowerCase();
  }

  String _normalizePhoneNumber(
      String value,
      ) {
    return value.replaceAll(
      RegExp(r'[^0-9+]'),
      '',
    );
  }

  String _cleanErrorMessage(
      Object error,
      ) {
    String msg = error.toString();
    // Clean Exception prefix to make UI display error details directly
    if (msg.startsWith('Exception: ')) {
      msg = msg.substring('Exception: '.length);
    }
    return msg
        .replaceFirst('Bad state: ', '')
        .replaceFirst('Invalid argument(s): ', '')
        .trim();
  }

  Future<void> toggleTorch() async {
    if (_isClosed) {
      return;
    }

    try {
      await scannerController.toggleTorch();

      isTorchOn.toggle();
      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = 'Flashlight is not available on this device_service.';
    }
  }

  Future<void> switchCamera() async {
    if (isSwitchingCamera.value || isProcessing.value || _isClosed) {
      return;
    }

    isSwitchingCamera.value = true;

    try {
      await scannerController.switchCamera();

      isTorchOn.value = false;
      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = 'Unable to switch the camera.';
    } finally {
      isSwitchingCamera.value = false;
    }
  }

  Future<void> restartScanner() async {
    if (_isClosed) {
      return;
    }

    isProcessing.value = false;
    scannedValue.value = '';
    errorMessage.value = '';

    await _startScanner();
  }

  Future<void> _startScanner() async {
    if (_isClosed) {
      return;
    }

    try {
      debugPrint('CAMERA: Starting scanner...');

      await scannerController.start();

      debugPrint('CAMERA: Scanner started successfully');
      debugPrint(
        'CAMERA: Is running = '
            '${scannerController.value.isRunning}',
      );
    } catch (error, stackTrace) {
      debugPrint('CAMERA START ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!_isClosed) {
        errorMessage.value =
        'Unable to start the camera.';
      }
    }
  }

  Future<void> _stopScanner() async {
    if (_isClosed) {
      return;
    }

    try {
      await scannerController.stop();
    } catch (error) {
      debugPrint(
        'Scanner stop error: $error',
      );
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  void closeScanner() {
    if (_isClosed) {
      return;
    }

    Get.back();
  }

  @override
  void onClose() {
    _isClosed = true;

    WidgetsBinding.instance.removeObserver(
      this,
    );

    unawaited(
      scannerController.dispose(),
    );

    super.onClose();
  }
}