import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_message_model.dart';

class ChatCameraService {
  final ImagePicker _imagePicker = ImagePicker();

  bool _isOpeningCamera = false;
  bool _isPickingFile = false;
  bool _isPickingLocation = false;

  bool get isOpeningCamera {
    return _isOpeningCamera;
  }

  bool get isPickingFile {
    return _isPickingFile;
  }

  bool get isPickingLocation {
    return _isPickingLocation;
  }

  Future<ChatMessageModel?> takePhoto() async {
    if (_isOpeningCamera) {
      return null;
    }

    try {
      _isOpeningCamera = true;

      XFile? capturedPhoto =
      await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1600,
        preferredCameraDevice:
        CameraDevice.rear,
      );

      if (capturedPhoto == null) {
        return null;
      }

      return ChatMessageModel(
        id: DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        text: '',
        sentAt: DateTime.now(),
        isMe: true,
        isRead: false,
        type: ChatMessageType.image,
        mediaPath: capturedPhoto.path,
      );
    } finally {
      _isOpeningCamera = false;
    }
  }

  Future<ChatMessageModel?> pickFromGallery() async {
    if (_isOpeningCamera) {
      return null;
    }

    try {
      _isOpeningCamera = true;

      XFile? pickedImage =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );

      if (pickedImage == null) {
        return null;
      }

      return ChatMessageModel(
        id: DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        text: '',
        sentAt: DateTime.now(),
        isMe: true,
        isRead: false,
        type: ChatMessageType.image,
        mediaPath: pickedImage.path,
      );
    } finally {
      _isOpeningCamera = false;
    }
  }

  Future<ChatMessageModel?> pickFile() async {
    if (_isPickingFile) {
      return null;
    }

    try {
      _isPickingFile = true;

      FilePickerResult? result =
      await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: false,
      );

      if (result == null ||
          result.files.isEmpty) {
        return null;
      }

      PlatformFile pickedFile =
          result.files.first;

      String? path = pickedFile.path;

      if (path == null || path.isEmpty) {
        throw Exception(
          'Could not read the selected file.',
        );
      }

      return ChatMessageModel(
        id: DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        text: pickedFile.name,
        sentAt: DateTime.now(),
        isMe: true,
        isRead: false,
        type: ChatMessageType.file,
        mediaPath: path,
      );
    } finally {
      _isPickingFile = false;
    }
  }

  Future<ChatMessageModel?> pickLocation() async {
    if (_isPickingLocation) {
      return null;
    }

    try {
      _isPickingLocation = true;

      bool serviceEnabled =
      await Geolocator
          .isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw ChatLocationException(
          message:
          'Location services are disabled. Please enable location services.',
          type:
          ChatLocationErrorType.serviceDisabled,
        );
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission ==
          LocationPermission.denied) {
        throw ChatLocationException(
          message:
          'Location permission was denied.',
          type:
          ChatLocationErrorType.permissionDenied,
        );
      }

      if (permission ==
          LocationPermission.deniedForever) {
        throw ChatLocationException(
          message:
          'Location permission is permanently denied. Please enable it in Settings.',
          type: ChatLocationErrorType
              .permissionDeniedForever,
        );
      }

      bool permissionGranted =
          permission ==
              LocationPermission.whileInUse ||
              permission ==
                  LocationPermission.always;

      if (!permissionGranted) {
        throw ChatLocationException(
          message:
          'Location permission is unavailable.',
          type:
          ChatLocationErrorType.permissionDenied,
        );
      }

      Position position =
      await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(
            seconds: 20,
          ),
        ),
      );

      String latitude =
      position.latitude.toStringAsFixed(6);

      String longitude =
      position.longitude.toStringAsFixed(6);

      return ChatMessageModel(
        id: DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        text: '$latitude, $longitude',
        sentAt: DateTime.now(),
        isMe: true,
        isRead: false,
        type: ChatMessageType.location,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } finally {
      _isPickingLocation = false;
    }
  }

  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }
}

enum ChatLocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class ChatLocationException
    implements Exception {
  final String message;
  final ChatLocationErrorType type;

  ChatLocationException({
    required this.message,
    required this.type,
  });

  @override
  String toString() {
    return message;
  }
}