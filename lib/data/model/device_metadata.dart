class DeviceMetadata {
  final String deviceId;
  final String deviceName;
  final String appVersion;
  final String platform;

  const DeviceMetadata({
    required this.deviceId,
    required this.deviceName,
    required this.appVersion,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'appVersion': appVersion,
      'platform': platform,
    };
  }
}