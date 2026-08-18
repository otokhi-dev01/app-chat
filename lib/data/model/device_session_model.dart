class DeviceSessionModel {
  final String id;
  final String deviceName;
  final String appVersion;
  final String platform;
  final String location;
  final String ipAddress;
  final DateTime? lastActiveAt;
  final bool isCurrent;
  final bool isOnline;

  const DeviceSessionModel({
    required this.id,
    required this.deviceName,
    required this.appVersion,
    required this.platform,
    required this.location,
    required this.ipAddress,
    required this.lastActiveAt,
    required this.isCurrent,
    required this.isOnline,
  });

  factory DeviceSessionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeviceSessionModel(
      id: json['id']?.toString() ?? '',
      deviceName:
      json['deviceName']?.toString() ??
          'Unknown device',
      appVersion:
      json['appVersion']?.toString() ?? '',
      platform:
      json['platform']?.toString() ?? 'unknown',
      location:
      json['location']?.toString() ?? '',
      ipAddress:
      json['ipAddress']?.toString() ?? '',
      lastActiveAt: DateTime.tryParse(
        json['lastActiveAt']?.toString() ?? '',
      ),
      isCurrent: _parseBool(json['isCurrent']),
      isOnline: _parseBool(json['isOnline']),
    );
  }

  String get statusText {
    if (isCurrent) {
      return 'Current device';
    }

    if (isOnline) {
      return 'Online';
    }

    return 'Offline';
  }

  String get platformName {
    switch (platform.toLowerCase()) {
      case 'ios':
        return 'iPhone or iPad';

      case 'android':
        return 'Android';

      case 'macos':
        return 'Mac';

      case 'windows':
        return 'Windows';

      case 'linux':
        return 'Linux';

      case 'web':
        return 'Web browser';

      default:
        return 'Unknown';
    }
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    return value == 1 ||
        value == '1' ||
        value?.toString().toLowerCase() == 'true';
  }
}