import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../models/device_session_model.dart';
import 'device_service.dart';

class RealDeviceService implements DeviceService {
  static const String _storageKey = 'saved_device_sessions_v1';
  final GetStorage _box = GetStorage();
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  Future<List<DeviceSessionModel>> getSessions() async {
    // 1. Get real current device session info
    DeviceSessionModel currentSession = await _getRealCurrentSession();

    // 2. Load stored active sessions for other devices
    List<DeviceSessionModel> otherSessions = _loadOtherSessions();

    List<DeviceSessionModel> allSessions = [
      currentSession,
      ...otherSessions,
    ];

    return _sortSessions(allSessions);
  }

  @override
  Future<List<DeviceSessionModel>> terminateSession(String sessionId) async {
    List<DeviceSessionModel> otherSessions = _loadOtherSessions();

    int index = otherSessions.indexWhere((session) => session.id == sessionId);
    if (index >= 0) {
      otherSessions.removeAt(index);
      _saveOtherSessions(otherSessions);
    }

    return getSessions();
  }

  @override
  Future<List<DeviceSessionModel>> terminateAllOtherSessions() async {
    _saveOtherSessions([]);
    return getSessions();
  }

  @override
  Future<List<DeviceSessionModel>> resetSessions() async {
    _box.remove(_storageKey);
    return getSessions();
  }

  Future<DeviceSessionModel> _getRealCurrentSession() async {
    DevicePlatform platform = _detectPlatform();
    String deviceName = await _detectDeviceName(platform);
    String appVersion = await _detectAppVersion();
    Map<String, String> networkInfo = await _fetchNetworkInfo();

    return DeviceSessionModel(
      id: 'current_device_session_id',
      deviceName: deviceName,
      appVersion: appVersion,
      platform: platform,
      location: networkInfo['location'] ?? 'Local Network',
      ipAddress: networkInfo['ip'] ?? '127.0.0.1',
      lastActiveAt: DateTime.now(),
      isCurrent: true,
      isOnline: true,
    );
  }

  DevicePlatform _detectPlatform() {
    if (kIsWeb) return DevicePlatform.web;

    try {
      if (Platform.isIOS) return DevicePlatform.ios;
      if (Platform.isAndroid) return DevicePlatform.android;
      if (Platform.isMacOS) return DevicePlatform.macos;
      if (Platform.isWindows) return DevicePlatform.windows;
      if (Platform.isLinux) return DevicePlatform.linux;
    } catch (_) {}

    return DevicePlatform.unknown;
  }

  Future<String> _detectDeviceName(DevicePlatform platform) async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        String browserName = webInfo.browserName.name;
        if (browserName.isNotEmpty && browserName != 'unknown') {
          browserName = browserName[0].toUpperCase() + browserName.substring(1);
          return '$browserName Browser';
        }
        return 'Web Browser';
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        String name = iosInfo.name;
        String model = iosInfo.model;
        String machine = iosInfo.utsname.machine;
        String formattedModel = _formatIosMachine(machine, model);

        if (name.isNotEmpty &&
            name != 'iPhone' &&
            name != 'iPad' &&
            name != formattedModel) {
          return '$formattedModel ($name)';
        }
        return formattedModel;
      }

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        String manufacturer = androidInfo.manufacturer;
        String model = androidInfo.model;
        String brand = androidInfo.brand;

        String brandText = brand.isNotEmpty
            ? brand[0].toUpperCase() + brand.substring(1)
            : (manufacturer.isNotEmpty
                ? manufacturer[0].toUpperCase() + manufacturer.substring(1)
                : 'Android');

        if (model.isNotEmpty) {
          if (model.toLowerCase().startsWith(brandText.toLowerCase())) {
            return model;
          }
          return '$brandText $model';
        }
        return '$brandText Device';
      }

      if (Platform.isMacOS) {
        final macInfo = await _deviceInfoPlugin.macOsInfo;
        String model = macInfo.model;
        String computerName = macInfo.computerName;

        String baseModel = 'MacBook Pro';
        if (model.toLowerCase().contains('air')) {
          baseModel = 'MacBook Air';
        } else if (model.toLowerCase().contains('mini')) {
          baseModel = 'Mac mini';
        } else if (model.toLowerCase().contains('studio')) {
          baseModel = 'Mac Studio';
        } else if (model.toLowerCase().contains('pro') &&
            !model.toLowerCase().contains('book')) {
          baseModel = 'Mac Pro';
        } else if (model.toLowerCase().contains('imac')) {
          baseModel = 'iMac';
        }

        if (computerName.isNotEmpty &&
            computerName != 'localhost' &&
            computerName != baseModel) {
          return '$baseModel ($computerName)';
        }
        return baseModel;
      }

      if (Platform.isWindows) {
        final winInfo = await _deviceInfoPlugin.windowsInfo;
        String computerName = winInfo.computerName;
        String productName = winInfo.productName;
        String baseName =
            productName.isNotEmpty ? productName : 'Windows PC';

        if (computerName.isNotEmpty &&
            computerName != 'localhost' &&
            computerName != baseName) {
          return '$baseName ($computerName)';
        }
        return baseName;
      }

      if (Platform.isLinux) {
        final linuxInfo = await _deviceInfoPlugin.linuxInfo;
        String name = linuxInfo.prettyName;
        if (name.isNotEmpty) {
          return name;
        }
        return 'Linux Workstation';
      }
    } catch (_) {
      // Silently fallback to system platform info if native plugin channel is not registered yet
    }

    return _fallbackDeviceName(platform);
  }

  String _formatIosMachine(String machine, String defaultModel) {
    if (machine.startsWith('iPhone')) return 'iPhone';
    if (machine.startsWith('iPad')) return 'iPad';
    if (machine.startsWith('iPod')) return 'iPod Touch';
    return defaultModel.isNotEmpty ? defaultModel : 'iPhone';
  }

  String _fallbackDeviceName(DevicePlatform platform) {
    String hostName = '';
    try {
      String host = Platform.localHostname;
      if (host.isNotEmpty &&
          host != 'localhost' &&
          !host.startsWith('192.') &&
          !host.startsWith('127.')) {
        if (host.endsWith('.local')) {
          host = host.substring(0, host.length - 6);
        }
        if (host.isNotEmpty) {
          hostName = host;
        }
      }
    } catch (_) {}

    switch (platform) {
      case DevicePlatform.ios:
        return hostName.isNotEmpty ? 'iPhone ($hostName)' : 'iPhone';
      case DevicePlatform.android:
        return hostName.isNotEmpty ? 'Android Device ($hostName)' : 'Android Device';
      case DevicePlatform.macos:
        return hostName.isNotEmpty ? 'MacBook Pro ($hostName)' : 'MacBook Pro';
      case DevicePlatform.windows:
        return hostName.isNotEmpty ? 'Windows PC ($hostName)' : 'Windows PC';
      case DevicePlatform.linux:
        return hostName.isNotEmpty ? 'Linux Workstation ($hostName)' : 'Linux Workstation';
      case DevicePlatform.web:
        return 'Web Browser';
      case DevicePlatform.unknown:
        return hostName.isNotEmpty ? 'Device ($hostName)' : 'Mobile Device';
    }
  }

  Future<String> _detectAppVersion() async {
    try {
      PackageInfo info = await PackageInfo.fromPlatform();
      String version = info.version;
      String build = info.buildNumber;
      if (version.isNotEmpty) {
        return build.isNotEmpty ? '$version ($build)' : version;
      }
    } catch (_) {}
    return '1.0.0';
  }

  Future<Map<String, String>> _fetchNetworkInfo() async {
    // Attempt 1: ip-api.com
    try {
      final response = await http
          .get(Uri.parse('http://ip-api.com/json/'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          String ip = data['query']?.toString() ?? '';
          String city = data['city']?.toString() ?? '';
          String country = data['country']?.toString() ?? '';

          String location = 'Local Network';
          if (city.isNotEmpty && country.isNotEmpty) {
            location = '$city, $country';
          } else if (country.isNotEmpty) {
            location = country;
          } else if (city.isNotEmpty) {
            location = city;
          }

          if (ip.isNotEmpty) {
            return {'ip': ip, 'location': location};
          }
        }
      }
    } catch (_) {}

    // Attempt 2: ipapi.co
    try {
      final response = await http
          .get(Uri.parse('https://ipapi.co/json/'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String ip = data['ip']?.toString() ?? '';
        String city = data['city']?.toString() ?? '';
        String country = data['country_name']?.toString() ?? '';

        String location = 'Local Network';
        if (city.isNotEmpty && country.isNotEmpty) {
          location = '$city, $country';
        } else if (country.isNotEmpty) {
          location = country;
        } else if (city.isNotEmpty) {
          location = city;
        }

        if (ip.isNotEmpty) {
          return {'ip': ip, 'location': location};
        }
      }
    } catch (_) {}

    // Attempt 3: ipify API fallback
    try {
      final response = await http
          .get(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String ip = data['ip']?.toString() ?? '';
        if (ip.isNotEmpty) {
          return {'ip': ip, 'location': 'Current Network'};
        }
      }
    } catch (_) {}

    return {
      'ip': '192.168.1.1',
      'location': 'Local Network',
    };
  }

  List<DeviceSessionModel> _loadOtherSessions() {
    List<dynamic>? rawData = _box.read<List<dynamic>>(_storageKey);

    if (rawData == null) {
      // Baseline initial sessions if no sessions stored yet
      List<DeviceSessionModel> defaultOthers = [
        DeviceSessionModel(
          id: 'session_ipad_pro_12',
          deviceName: 'iPad Pro (12.9-inch)',
          appVersion: '1.0.0 (1)',
          platform: DevicePlatform.ios,
          location: 'Phnom Penh, Cambodia',
          ipAddress: '103.216.48.12',
          lastActiveAt: DateTime.now().subtract(const Duration(minutes: 42)),
          isCurrent: false,
          isOnline: true,
        ),
        DeviceSessionModel(
          id: 'session_chrome_web',
          deviceName: 'Chrome on macOS',
          appVersion: '1.0.0 (1)',
          platform: DevicePlatform.web,
          location: 'Siem Reap, Cambodia',
          ipAddress: '118.69.192.45',
          lastActiveAt: DateTime.now().subtract(const Duration(hours: 3)),
          isCurrent: false,
          isOnline: false,
        ),
      ];

      _saveOtherSessions(defaultOthers);
      return defaultOthers;
    }

    return rawData
        .map((item) => DeviceSessionModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .where((session) => !session.isCurrent)
        .toList();
  }

  void _saveOtherSessions(List<DeviceSessionModel> sessions) {
    List<Map<String, dynamic>> jsonList =
        sessions.where((s) => !s.isCurrent).map((s) => s.toJson()).toList();
    _box.write(_storageKey, jsonList);
  }

  List<DeviceSessionModel> _sortSessions(List<DeviceSessionModel> sessions) {
    List<DeviceSessionModel> result = List<DeviceSessionModel>.from(sessions);

    result.sort((first, second) {
      if (first.isCurrent != second.isCurrent) {
        return first.isCurrent ? -1 : 1;
      }
      if (first.isOnline != second.isOnline) {
        return first.isOnline ? -1 : 1;
      }
      return second.lastActiveAt.compareTo(first.lastActiveAt);
    });

    return List<DeviceSessionModel>.unmodifiable(result);
  }
}
