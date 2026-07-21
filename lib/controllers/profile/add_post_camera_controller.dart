import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/add_post_capture_result.dart';

enum AddPostCameraMode {
  photo,
  video,
}

class AddPostCameraController
    extends GetxController
    with WidgetsBindingObserver {
  final Rxn<CameraController> camera =
  Rxn<CameraController>();

  final RxBool isInitializing = true.obs;
  final RxBool isBusy = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool showGrid = false.obs;

  final RxString errorMessage = ''.obs;

  final Rx<FlashMode> flashMode =
      FlashMode.off.obs;

  final Rx<AddPostCameraMode> selectedMode =
      AddPostCameraMode.photo.obs;

  final ImagePicker _imagePicker =
  ImagePicker();

  List<CameraDescription> _cameras =
  <CameraDescription>[];

  int _cameraIndex = 0;
  bool _isDisposed = false;

  bool get isCameraReady {
    CameraController? current = camera.value;

    return current != null &&
        current.value.isInitialized;
  }

  bool get hasMultipleCameras {
    return _cameras.length > 1;
  }

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(
      this,
    );

    unawaited(
      initializeCamera(),
    );
  }

  @override
  void onClose() {
    _isDisposed = true;

    WidgetsBinding.instance.removeObserver(
      this,
    );

    unawaited(
      _disposeCamera(),
    );

    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    if (_isDisposed) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      unawaited(
        _disposeCamera(),
      );

      return;
    }

    if (state == AppLifecycleState.resumed) {
      unawaited(
        _openCamera(
          _cameraIndex,
        ),
      );
    }
  }

  Future<void> initializeCamera() async {
    isInitializing.value = true;
    errorMessage.value = '';

    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        errorMessage.value =
        'No camera was found on this device.';

        return;
      }

      int backCameraIndex =
      _cameras.indexWhere(
            (CameraDescription camera) {
          return camera.lensDirection ==
              CameraLensDirection.back;
        },
      );

      _cameraIndex = backCameraIndex >= 0
          ? backCameraIndex
          : 0;

      await _openCamera(
        _cameraIndex,
      );
    } on CameraException catch (error) {
      errorMessage.value =
          _cameraErrorMessage(error);
    } catch (error) {
      errorMessage.value =
      'Unable to open the camera.';
    } finally {
      if (!_isDisposed) {
        isInitializing.value = false;
      }
    }
  }

  Future<void> _openCamera(
      int index,
      ) async {
    if (_isDisposed ||
        _cameras.isEmpty ||
        index < 0 ||
        index >= _cameras.length) {
      return;
    }

    isInitializing.value = true;
    errorMessage.value = '';

    CameraController? previousController =
        camera.value;

    camera.value = null;

    if (previousController != null) {
      await previousController.dispose();
    }

    CameraController nextController =
    CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await nextController.initialize();

      if (_isDisposed) {
        await nextController.dispose();
        return;
      }

      try {
        await nextController.setFlashMode(
          FlashMode.off,
        );
      } catch (error) {
        // Some front cameras do not support flash.
      }

      flashMode.value = FlashMode.off;
      camera.value = nextController;
    } on CameraException catch (error) {
      await nextController.dispose();

      errorMessage.value =
          _cameraErrorMessage(error);
    } catch (error) {
      await nextController.dispose();

      errorMessage.value =
      'Unable to initialize the camera.';
    } finally {
      if (!_isDisposed) {
        isInitializing.value = false;
      }
    }
  }

  Future<void> _disposeCamera() async {
    CameraController? current = camera.value;

    camera.value = null;

    if (current != null) {
      await current.dispose();
    }
  }

  void toggleGrid() {
    showGrid.toggle();
  }

  Future<void> changeMode(
      AddPostCameraMode mode,
      ) async {
    if (isRecording.value ||
        selectedMode.value == mode) {
      return;
    }

    selectedMode.value = mode;

    CameraController? current = camera.value;

    if (current == null ||
        !current.value.isInitialized) {
      return;
    }

    try {
      await current.setFlashMode(
        FlashMode.off,
      );

      flashMode.value = FlashMode.off;
    } catch (error) {
      // Ignore unsupported flash mode.
    }
  }

  Future<void> cycleFlash() async {
    CameraController? current = camera.value;

    if (current == null ||
        !current.value.isInitialized ||
        isRecording.value ||
        isBusy.value) {
      return;
    }

    FlashMode nextMode;

    if (selectedMode.value ==
        AddPostCameraMode.video) {
      nextMode =
      flashMode.value == FlashMode.torch
          ? FlashMode.off
          : FlashMode.torch;
    } else if (flashMode.value ==
        FlashMode.off) {
      nextMode = FlashMode.auto;
    } else if (flashMode.value ==
        FlashMode.auto) {
      nextMode = FlashMode.always;
    } else {
      nextMode = FlashMode.off;
    }

    try {
      await current.setFlashMode(
        nextMode,
      );

      flashMode.value = nextMode;
    } on CameraException catch (error) {
      errorMessage.value =
      'Flash is unavailable: ${error.description ?? error.code}';
    }
  }

  Future<void> switchCamera() async {
    if (!hasMultipleCameras ||
        isRecording.value ||
        isBusy.value) {
      return;
    }

    _cameraIndex =
        (_cameraIndex + 1) %
            _cameras.length;

    await _openCamera(
      _cameraIndex,
    );
  }

  Future<void> openGallery() async {
    if (isBusy.value ||
        isRecording.value) {
      return;
    }

    isBusy.value = true;

    try {
      XFile? selectedFile;

      if (selectedMode.value ==
          AddPostCameraMode.photo) {
        selectedFile =
        await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 95,
        );
      } else {
        selectedFile =
        await _imagePicker.pickVideo(
          source: ImageSource.gallery,
        );
      }

      if (_isDisposed ||
          selectedFile == null ||
          selectedFile.path.trim().isEmpty) {
        return;
      }

      AddPostCaptureResult result =
      AddPostCaptureResult(
        path: selectedFile.path,
        type: selectedMode.value ==
            AddPostCameraMode.photo
            ? AddPostMediaType.photo
            : AddPostMediaType.video,
        fromGallery: true,
      );

      isBusy.value = false;

      Get.back<AddPostCaptureResult>(
        result: result,
      );
    } catch (error) {
      errorMessage.value =
      'Unable to open the gallery.';
    } finally {
      if (!_isDisposed) {
        isBusy.value = false;
      }
    }
  }

  Future<void> capture() async {
    if (!isCameraReady ||
        isBusy.value) {
      return;
    }

    if (selectedMode.value ==
        AddPostCameraMode.photo) {
      await _takePhoto();
      return;
    }

    if (isRecording.value) {
      await _stopVideoRecording();
    } else {
      await _startVideoRecording();
    }
  }

  Future<void> _takePhoto() async {
    CameraController? current = camera.value;

    if (current == null ||
        !current.value.isInitialized ||
        current.value.isTakingPicture) {
      return;
    }

    isBusy.value = true;

    try {
      XFile file =
      await current.takePicture();

      if (_isDisposed) {
        return;
      }

      AddPostCaptureResult result =
      AddPostCaptureResult(
        path: file.path,
        type: AddPostMediaType.photo,
        fromGallery: false,
      );

      isBusy.value = false;

      Get.back<AddPostCaptureResult>(
        result: result,
      );
    } on CameraException catch (error) {
      errorMessage.value =
      'Unable to take photo: ${error.description ?? error.code}';
    } finally {
      if (!_isDisposed) {
        isBusy.value = false;
      }
    }
  }

  Future<void> _startVideoRecording() async {
    CameraController? current = camera.value;

    if (current == null ||
        !current.value.isInitialized ||
        current.value.isRecordingVideo) {
      return;
    }

    isBusy.value = true;

    try {
      await current.startVideoRecording();

      if (!_isDisposed) {
        isRecording.value = true;
      }
    } on CameraException catch (error) {
      errorMessage.value =
      'Unable to start recording: ${error.description ?? error.code}';
    } finally {
      if (!_isDisposed) {
        isBusy.value = false;
      }
    }
  }

  Future<void> _stopVideoRecording() async {
    CameraController? current = camera.value;

    if (current == null ||
        !current.value.isRecordingVideo) {
      return;
    }

    isBusy.value = true;

    try {
      XFile file =
      await current.stopVideoRecording();

      if (_isDisposed) {
        return;
      }

      isRecording.value = false;

      AddPostCaptureResult result =
      AddPostCaptureResult(
        path: file.path,
        type: AddPostMediaType.video,
        fromGallery: false,
      );

      isBusy.value = false;

      Get.back<AddPostCaptureResult>(
        result: result,
      );
    } on CameraException catch (error) {
      errorMessage.value =
      'Unable to stop recording: ${error.description ?? error.code}';
    } finally {
      if (!_isDisposed) {
        isRecording.value = false;
        isBusy.value = false;
      }
    }
  }

  Future<void> closeCamera() async {
    CameraController? current = camera.value;

    if (current != null &&
        current.value.isRecordingVideo) {
      try {
        await current.stopVideoRecording();
      } catch (error) {
        // Discard unfinished recording.
      }
    }

    isRecording.value = false;

    Get.back();
  }

  String _cameraErrorMessage(
      CameraException error,
      ) {
    if (error.code ==
        'CameraAccessDenied' ||
        error.code ==
            'CameraAccessDeniedWithoutPrompt') {
      return 'Camera access was denied. Enable it from your iPhone settings.';
    }

    if (error.code ==
        'AudioAccessDenied' ||
        error.code ==
            'AudioAccessDeniedWithoutPrompt') {
      return 'Microphone access was denied. Enable it to record videos.';
    }

    return error.description ??
        'Unable to access the camera.';
  }
}