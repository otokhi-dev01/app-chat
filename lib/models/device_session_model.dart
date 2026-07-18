enum DevicePlatform {
  ios,
  android,
  macos,
  windows,
  linux,
  web,
  unknown,
}

class DeviceSessionModel {
  final String id;
  final String deviceName;
  final String appVersion;
  final DevicePlatform platform;
  final String location;
  final String ipAddress;
  final DateTime lastActiveAt;
  final bool isCurrent;
  final bool isOnline;

  DeviceSessionModel({
    required this.id,
    required this.deviceName,
    required this.appVersion,
    required this.platform,
    required this.location,
    required this.ipAddress,
    required this.lastActiveAt,
    this.isCurrent = false,
    this.isOnline = false,
  });

  String get platformText {
    switch (platform) {
      case DevicePlatform.ios:
        return 'iOS';

      case DevicePlatform.android:
        return 'Android';

      case DevicePlatform.macos:
        return 'macOS';

      case DevicePlatform.windows:
        return 'Windows';

      case DevicePlatform.linux:
        return 'Linux';

      case DevicePlatform.web:
        return 'Web';

      case DevicePlatform.unknown:
        return 'Unknown';
    }
  }

  String get lastActiveText {
    if (isCurrent) {
      return 'This device';
    }

    if (isOnline) {
      return 'Online';
    }

    DateTime now = DateTime.now();
    Duration difference =
    now.difference(lastActiveAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return '${lastActiveAt.day}/${lastActiveAt.month}/${lastActiveAt.year}';
  }

  DeviceSessionModel copyWith({
    String? id,
    String? deviceName,
    String? appVersion,
    DevicePlatform? platform,
    String? location,
    String? ipAddress,
    DateTime? lastActiveAt,
    bool? isCurrent,
    bool? isOnline,
  }) {
    return DeviceSessionModel(
      id: id ?? this.id,
      deviceName:
      deviceName ?? this.deviceName,
      appVersion:
      appVersion ?? this.appVersion,
      platform: platform ?? this.platform,
      location: location ?? this.location,
      ipAddress:
      ipAddress ?? this.ipAddress,
      lastActiveAt:
      lastActiveAt ?? this.lastActiveAt,
      isCurrent:
      isCurrent ?? this.isCurrent,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  factory DeviceSessionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeviceSessionModel(
      id: json['id']?.toString() ?? '',
      deviceName:
      json['deviceName']?.toString() ??
          '',
      appVersion:
      json['appVersion']?.toString() ??
          '',
      platform: _parsePlatform(
        json['platform']?.toString(),
      ),
      location:
      json['location']?.toString() ?? '',
      ipAddress:
      json['ipAddress']?.toString() ??
          '',
      lastActiveAt: DateTime.tryParse(
        json['lastActiveAt']
            ?.toString() ??
            '',
      ) ??
          DateTime.now(),
      isCurrent:
      json['isCurrent'] == true,
      isOnline: json['isOnline'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceName': deviceName,
      'appVersion': appVersion,
      'platform': platform.name,
      'location': location,
      'ipAddress': ipAddress,
      'lastActiveAt':
      lastActiveAt.toIso8601String(),
      'isCurrent': isCurrent,
      'isOnline': isOnline,
    };
  }

  static DevicePlatform _parsePlatform(
      String? value,
      ) {
    return DevicePlatform.values.firstWhere(
          (DevicePlatform platform) {
        return platform.name == value;
      },
      orElse: () {
        return DevicePlatform.unknown;
      },
    );
  }
}