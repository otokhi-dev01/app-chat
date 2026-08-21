import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../models/contact_model.dart';
import '../../models/user_model.dart';
import '../../route/app_route.dart';
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
    autoStart: false, // <-- was true
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
  bool _isStarting = false;


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_startScanner()); // single, explicit start
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

    if (state == AppLifecycleState.resumed &&
        !isProcessing.value &&
        !_isStarting &&
        !scannerController.value.isRunning) {
      unawaited(_startScanner());
    }
  }


  Future<void> handleDetect(
      BarcodeCapture capture,
      ) async {
    if (isProcessing.value || _isClosed) {
      debugPrint('QR: skipped detect (isProcessing=${isProcessing.value}, isClosed=$_isClosed)');
      return;
    }

    String rawValue = _getBarcodeValue(capture);
    debugPrint('QR: raw barcode value = "$rawValue"');

    if (rawValue.isEmpty) {
      debugPrint('QR: empty barcode value, ignoring');
      return;
    }

    isProcessing.value = true;
    scannedValue.value = rawValue;
    errorMessage.value = '';

    await HapticFeedback.mediumImpact();
    await _stopScanner();

    AppUserModel? user; // hoisted so it's visible in catch

    try {
      String userValue = _extractUserValue(rawValue);
      debugPrint('QR: extracted user value = "$userValue"');

      if (userValue.isEmpty) {
        throw StateError(
          'This QR code does not contain a valid user.',
        );
      }

      debugPrint('QR: looking up user...');
      user = await _findUser(userValue);
      debugPrint('QR: _findUser result -> id=${user?.id}, username=${user?.username}');

      if (user == null) {
        throw StateError(
          'User not found.',
        );
      }

      debugPrint('QR: fetching current user...');
      AppUserModel? currentUser = await appUserService.getCurrentUser();
      debugPrint('QR: currentUser -> id=${currentUser?.id}');

      if (currentUser?.id == user.id) {
        throw StateError(
          'You cannot add yourself as a contact.',
        );
      }

      debugPrint('QR: creating contact for userId=${user.id}...');
      ContactModel? contact = await contactService.createContact(
        contactUserId: user.id,
      );
      debugPrint('QR: createContact result -> id=${contact?.id}');

      if (contact == null) {
        throw StateError(
          'Unable to add this user to contacts.',
        );
      }

      if (_isClosed) {
        debugPrint('QR: controller already closed, skipping navigation');
        return;
      }

      debugPrint('QR: SUCCESS — closing scanner and opening profile');
      Get.back<ContactModel>(result: contact);
      Get.toNamed(AppRoutes.profileDetail, arguments: {'userId': user.id});
    } catch (error, stackTrace) {
      isProcessing.value = false;

      if (_isDuplicateContactError(error) && user != null) {
        debugPrint('QR: contact already exists, opening profile for userId=${user.id}');
        if (!_isClosed) {
          Get.back();
          Get.toNamed(AppRoutes.profileDetail, arguments: {'userId': user.id});
        }
        return;
      }

      debugPrint('QR: ERROR in handleDetect -> $error');
      debugPrintStack(stackTrace: stackTrace);

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
      debugPrint('QR: _findUser -> trying getUserById("$cleanValue")');
      final result = await appUserService.getUserById(cleanValue);
      debugPrint('QR: _findUser -> getUserById SUCCESS: id=${result?.id}');
      return result;
    } catch (error) {
      debugPrint('QR: _findUser -> getUserById FAILED: $error');
    }

    // If it is not an ID, search by username or phone number.
    try {
      debugPrint('QR: _findUser -> falling back to searchUsers("$cleanValue")');
      final results = await appUserService.searchUsers(
        query: cleanValue,
      );
      debugPrint('QR: _findUser -> searchUsers returned ${results.length} result(s)');

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

        debugPrint(
          'QR: _findUser -> candidate id=${item.id} username=${item.username} '
              '-> matchesId=$matchesId matchesUsername=$matchesUsername matchesPhone=$matchesPhone',
        );

        if (matchesId || matchesUsername || matchesPhone) {
          return item;
        }
      }

      debugPrint('QR: _findUser -> no candidate matched');
      return null;
    } catch (error) {
      debugPrint('QR: _findUser -> searchUsers FAILED: $error');
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

  // ADD THIS NEW METHOD HERE
  bool _isDuplicateContactError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('409') || message.contains('already exist');
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
    if (_isClosed || _isStarting) {
      return;
    }

    if (scannerController.value.isRunning) {
      return;
    }

    _isStarting = true;

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
        errorMessage.value = 'Unable to start the camera.';
      }
    } finally {
      _isStarting = false;
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