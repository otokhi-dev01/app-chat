import '../models/device_session_model.dart';

abstract class DeviceService {
  Future<List<DeviceSessionModel>> getSessions();

  Future<List<DeviceSessionModel>> terminateSession(
      String sessionId,
      );

  Future<List<DeviceSessionModel>>
  terminateAllOtherSessions();

  Future<List<DeviceSessionModel>>
  resetSessions();
}