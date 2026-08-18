import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/device_metadata.dart';

class DeviceIdentityService extends GetxService {
  static const String _deviceIdKey =
      'installation_device_id';

  final FlutterSecureStorage secureStorage;
  final DeviceInfoPlugin deviceInfo;

  DeviceIdentityService({
    FlutterSecureStorage? secureStorage,
    DeviceInfoPlugin? deviceInfo,
  })  : secureStorage =
      secureStorage ??
          const FlutterSecureStorage(),
        deviceInfo =
            deviceInfo ?? DeviceInfoPlugin();

  Future<DeviceMetadata> getMetadata() async {
    final deviceId = await _getOrCreateDeviceId();
    final packageInfo =
    await PackageInfo.fromPlatform();

    return DeviceMetadata(
      deviceId: deviceId,
      deviceName: await _getDeviceName(),
      appVersion: packageInfo.version,
      platform: _getPlatform(),
    );
  }

  Future<String> _getOrCreateDeviceId() async {
    final existingId = await secureStorage.read(
      key: _deviceIdKey,
    );

    if (
    existingId != null &&
        existingId.trim().isNotEmpty) {
      return existingId;
    }

    final newId = const Uuid().v4();

    await secureStorage.write(
      key: _deviceIdKey,
      value: newId,
    );

    return newId;
  }

  String _getPlatform() {
    if (kIsWeb) {
      return 'web';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';

      case TargetPlatform.android:
        return 'android';

      case TargetPlatform.macOS:
        return 'macos';

      case TargetPlatform.windows:
        return 'windows';

      case TargetPlatform.linux:
        return 'linux';

      default:
        return 'unknown';
    }
  }

  Future<String> _getDeviceName() async {
    try {
      if (kIsWeb) {
        final info =
        await deviceInfo.webBrowserInfo;

        return info.browserName.name;
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          final info = await deviceInfo.iosInfo;

          return info.name.trim().isNotEmpty
              ? info.name
              : info.model;

        case TargetPlatform.android:
          final info =
          await deviceInfo.androidInfo;

          final manufacturer =
          info.manufacturer.trim();
          final model = info.model.trim();

          return [
            manufacturer,
            model,
          ].where((value) => value.isNotEmpty).join(' ');

        case TargetPlatform.macOS:
          final info = await deviceInfo.macOsInfo;

          return info.computerName;

        case TargetPlatform.windows:
          final info =
          await deviceInfo.windowsInfo;

          return info.computerName;

        case TargetPlatform.linux:
          final info = await deviceInfo.linuxInfo;

          return info.prettyName;

        default:
          return 'Unknown device';
      }
    } catch (_) {
      return 'Unknown device';
    }
  }
}