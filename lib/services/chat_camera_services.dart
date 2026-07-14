import 'package:image_picker/image_picker.dart';

import '../../../models/chat_message_model.dart';

class ChatCameraService {
  final ImagePicker _imagePicker = ImagePicker();

  bool _isOpeningCamera = false;

  bool get isOpeningCamera => _isOpeningCamera;

  Future<ChatMessageModel?> takePhoto() async {
    if (_isOpeningCamera) {
      return null;
    }

    try {
      _isOpeningCamera = true;

      XFile? capturedPhoto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1600,
        preferredCameraDevice: CameraDevice.rear,
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
}