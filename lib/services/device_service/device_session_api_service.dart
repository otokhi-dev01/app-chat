import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../models/device_session_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';
import 'device_identity_service.dart';

class DeviceSessionApiService extends GetxService {
  static const String _sessionIdKey =
      'current_device_session_id';

  final ApiService apiService;
  final AuthApiService authApiService;
  final DeviceIdentityService identityService;
  final FlutterSecureStorage secureStorage;

  DeviceSessionApiService({
    required this.apiService,
    required this.authApiService,
    required this.identityService,
    FlutterSecureStorage? secureStorage,
  }) : secureStorage =
      secureStorage ??
          const FlutterSecureStorage();

  Future<DeviceSessionModel>
  registerCurrentDevice() async {
    final token = await authApiService.requireToken();
    final metadata =
    await identityService.getMetadata();

    final json = await apiService.post(
      ApiConstants.deviceSessions,
      body: metadata.toJson(),
      token: token,
    );

    final session = DeviceSessionModel.fromJson(
      _extractMap(json),
    );

    await secureStorage.write(
      key: _sessionIdKey,
      value: session.id,
    );

    return session;
  }

  Future<List<DeviceSessionModel>>
  getDeviceSessions() async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.deviceSessions,
      token: token,
    );

    final data = json['data'];

    if (data is! List) {
      throw const FormatException(
        'The server returned an invalid device list.',
      );
    }

    return data
        .whereType<Map>()
        .map(
          (item) => DeviceSessionModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  Future<DeviceSessionModel> getDeviceSession(
      String sessionId,
      ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.deviceSessionById(sessionId),
      token: token,
    );

    return DeviceSessionModel.fromJson(
      _extractMap(json),
    );
  }

  Future<DeviceSessionModel> sendHeartbeat() async {
    final token = await authApiService.requireToken();

    final json = await apiService.patch(
      ApiConstants.currentDeviceHeartbeat,
      body: const <String, dynamic>{},
      token: token,
    );

    return DeviceSessionModel.fromJson(
      _extractMap(json),
    );
  }

  Future<int> terminateOtherSessions() async {
    final token = await authApiService.requireToken();

    final json = await apiService.delete(
      ApiConstants.otherDeviceSessions,
      token: token,
    );

    final value = json['terminatedCount'];

    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<String> terminateSession(
      String sessionId,
      ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.delete(
      ApiConstants.deviceSessionById(sessionId),
      token: token,
    );

    return json['message']?.toString() ??
        'Device session terminated successfully.';
  }

  Future<String?> getStoredSessionId() {
    return secureStorage.read(
      key: _sessionIdKey,
    );
  }

  Future<void> clearStoredSession() {
    return secureStorage.delete(
      key: _sessionIdKey,
    );
  }

  Map<String, dynamic> _extractMap(
      Map<String, dynamic> json,
      ) {
    final data = json['data'] ?? json;

    if (data is! Map) {
      throw const FormatException(
        'The server returned invalid device data.',
      );
    }

    return Map<String, dynamic>.from(data);
  }
}