import '../../data/mock_device_session_data.dart';
import '../../models/device_session_model.dart';
import '../device_service.dart';

class MockDeviceService
    implements DeviceService {
  final List<DeviceSessionModel> _sessions =
  MockDeviceSessionData.build();

  @override
  Future<List<DeviceSessionModel>>
  getSessions() async {
    await Future<void>.delayed(
      Duration(milliseconds: 450),
    );

    return _getSortedSessions();
  }

  @override
  Future<List<DeviceSessionModel>>
  terminateSession(
      String sessionId,
      ) async {
    await Future<void>.delayed(
      Duration(milliseconds: 350),
    );

    int index = _sessions.indexWhere(
          (DeviceSessionModel session) {
        return session.id == sessionId;
      },
    );

    if (index < 0) {
      throw StateError(
        'Device session was not found.',
      );
    }

    DeviceSessionModel session =
    _sessions[index];

    if (session.isCurrent) {
      throw StateError(
        'The current device cannot be terminated.',
      );
    }

    _sessions.removeAt(index);

    return _getSortedSessions();
  }

  @override
  Future<List<DeviceSessionModel>>
  terminateAllOtherSessions() async {
    await Future<void>.delayed(
      Duration(milliseconds: 550),
    );

    _sessions.removeWhere(
          (DeviceSessionModel session) {
        return !session.isCurrent;
      },
    );

    return _getSortedSessions();
  }

  @override
  Future<List<DeviceSessionModel>>
  resetSessions() async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    _sessions
      ..clear()
      ..addAll(
        MockDeviceSessionData.build(),
      );

    return _getSortedSessions();
  }

  List<DeviceSessionModel>
  _getSortedSessions() {
    List<DeviceSessionModel> result =
    List<DeviceSessionModel>.from(
      _sessions,
    );

    result.sort(
          (
          DeviceSessionModel first,
          DeviceSessionModel second,
          ) {
        if (first.isCurrent !=
            second.isCurrent) {
          return first.isCurrent ? -1 : 1;
        }

        if (first.isOnline !=
            second.isOnline) {
          return first.isOnline ? -1 : 1;
        }

        return second.lastActiveAt.compareTo(
          first.lastActiveAt,
        );
      },
    );

    return List<DeviceSessionModel>
        .unmodifiable(
      result,
    );
  }
}