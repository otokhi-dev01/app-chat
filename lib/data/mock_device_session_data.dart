import '../../models/device_session_model.dart';

class MockDeviceSessionData {
  static List<DeviceSessionModel> build() {
    DateTime now = DateTime.now();

    return <DeviceSessionModel>[
      DeviceSessionModel(
        id: 'device_session_current',
        deviceName: 'Mac M4’s iPhone',
        appVersion: 'AppChat 1.0.0',
        platform: DevicePlatform.ios,
        location: 'Phnom Penh, Cambodia',
        ipAddress: '203.0.113.18',
        lastActiveAt: now,
        isCurrent: true,
        isOnline: true,
      ),
      // DeviceSessionModel(
      //   id: 'device_session_macbook',
      //   deviceName: 'MacBook Pro',
      //   appVersion: 'AppChat Desktop 1.0.0',
      //   platform: DevicePlatform.macos,
      //   location: 'Phnom Penh, Cambodia',
      //   ipAddress: '203.0.113.21',
      //   lastActiveAt: now.subtract(
      //     Duration(minutes: 8),
      //   ),
      //   isCurrent: false,
      //   isOnline: true,
      // ),
      DeviceSessionModel(
        id: 'device_session_chrome',
        deviceName: 'Chrome on macOS',
        appVersion: 'AppChat Web',
        platform: DevicePlatform.web,
        location: 'Phnom Penh, Cambodia',
        ipAddress: '198.51.100.27',
        lastActiveAt: now.subtract(
          Duration(hours: 2),
        ),
        isCurrent: false,
        isOnline: false,
      ),
      DeviceSessionModel(
        id: 'device_session_android',
        deviceName: 'Samsung Galaxy S24',
        appVersion: 'AppChat 1.0.0',
        platform: DevicePlatform.android,
        location: 'Siem Reap, Cambodia',
        ipAddress: '192.0.2.44',
        lastActiveAt: now.subtract(
          Duration(days: 2),
        ),
        isCurrent: false,
        isOnline: false,
      ),
      DeviceSessionModel(
        id: 'device_session_windows',
        deviceName: 'Windows Desktop',
        appVersion: 'AppChat Desktop 1.0.0',
        platform: DevicePlatform.windows,
        location: 'Battambang, Cambodia',
        ipAddress: '192.0.2.61',
        lastActiveAt: now.subtract(
          Duration(days: 5),
        ),
        isCurrent: false,
        isOnline: false,
      ),
      DeviceSessionModel(
        id: 'device_session_linux',
        deviceName: 'Ubuntu Workstation',
        appVersion: 'AppChat Desktop 1.0.0',
        platform: DevicePlatform.linux,
        location: 'Phnom Penh, Cambodia',
        ipAddress: '198.51.100.42',
        lastActiveAt: now.subtract(
          Duration(days: 8),
        ),
        isCurrent: false,
        isOnline: false,
      ),
    ];
  }
}