import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

enum NotificationUpdateResult {
  enabled,
  disabled,
  denied,
  permanentlyDenied,
}

class NotificationSettingsService {
  static const String _notificationKey =
      'notifications_enabled';

  final GetStorage _storage = GetStorage();

  Future<bool> loadEnabledState() async {
    bool savedValue =
        _storage.read<bool>(_notificationKey) ?? false;

    if (!savedValue) {
      return false;
    }

    PermissionStatus status =
    await Permission.notification.status;

    if (!status.isGranted) {
      await _storage.write(
        _notificationKey,
        false,
      );

      return false;
    }

    return true;
  }

  Future<NotificationUpdateResult> updateEnabledState(
      bool enabled,
      ) async {
    if (!enabled) {
      await _storage.write(
        _notificationKey,
        false,
      );

      return NotificationUpdateResult.disabled;
    }

    PermissionStatus status =
    await Permission.notification.status;

    if (!status.isGranted) {
      status =
      await Permission.notification.request();
    }

    if (status.isGranted) {
      await _storage.write(
        _notificationKey,
        true,
      );

      return NotificationUpdateResult.enabled;
    }

    await _storage.write(
      _notificationKey,
      false,
    );

    if (status.isPermanentlyDenied ||
        status.isRestricted) {
      return NotificationUpdateResult
          .permanentlyDenied;
    }

    return NotificationUpdateResult.denied;
  }

  Future<bool> openSettings() async {
    return openAppSettings();
  }
}