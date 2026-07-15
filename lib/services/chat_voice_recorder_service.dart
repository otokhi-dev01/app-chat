import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

enum ChatMicPermissionError {
  /// User hasn't decided yet, or said no but the OS can still show the
  /// native prompt again.
  denied,

  /// User denied and the OS will never show the native prompt again —
  /// the only way forward is the Settings app.
  permanentlyDenied,

  /// Platform restriction (e.g. parental controls) — Settings can't help.
  restricted,
}

class ChatMicPermissionException implements Exception {
  final ChatMicPermissionError type;

  ChatMicPermissionException(this.type);

  @override
  String toString() {
    switch (type) {
      case ChatMicPermissionError.permanentlyDenied:
        return 'Microphone access is disabled for this app. '
            'Enable it in Settings to send voice messages.';
      case ChatMicPermissionError.restricted:
        return 'Microphone access is restricted on this device.';
      case ChatMicPermissionError.denied:
        return 'Microphone permission is required to record voice messages.';
    }
  }
}

class ChatVoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  DateTime? _startedAt;
  String? _currentPath;

  bool _isRecording = false;

  bool get isRecording {
    return _isRecording;
  }

  Duration get recordedDuration {
    DateTime? startedAt = _startedAt;

    if (startedAt == null) {
      return Duration.zero;
    }

    return DateTime.now().difference(startedAt);
  }

  /// Uses record's own hasPermission() as the real gate — on iOS this is
  /// what actually initializes/activates the native AVAudioSession for
  /// recording, not just a boolean check. If that fails, we fall back to
  /// permission_handler purely to figure out *why*, so the UI can show
  /// the right dialog (retry vs. Open Settings).
  Future<void> _ensurePermission() async {
    bool granted = await _recorder.hasPermission();

    if (granted) {
      return;
    }

    PermissionStatus status = await Permission.microphone.status;

    if (status.isPermanentlyDenied) {
      throw ChatMicPermissionException(
        ChatMicPermissionError.permanentlyDenied,
      );
    }

    if (status.isRestricted) {
      throw ChatMicPermissionException(
        ChatMicPermissionError.restricted,
      );
    }

    throw ChatMicPermissionException(
      ChatMicPermissionError.denied,
    );
  }

  static Future<bool> openSettings() {
    return openAppSettings();
  }

  Future<void> startRecording() async {
    if (_isRecording) {
      return;
    }

    await _ensurePermission();

    Directory directory =
    await getTemporaryDirectory();

    String path =
        '${directory.path}/voice_${DateTime.now().microsecondsSinceEpoch}.m4a';

    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    _currentPath = path;
    _startedAt = DateTime.now();
    _isRecording = true;
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) {
      return null;
    }

    String? path = await _recorder.stop();

    _isRecording = false;
    _startedAt = null;
    _currentPath = null;

    return path;
  }

  Future<void> cancelRecording() async {
    if (!_isRecording) {
      return;
    }

    await _recorder.cancel();

    String? path = _currentPath;

    if (path != null) {
      File file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    }

    _isRecording = false;
    _startedAt = null;
    _currentPath = null;
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}