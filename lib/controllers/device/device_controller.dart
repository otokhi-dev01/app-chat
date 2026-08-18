import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../models/device_session_model.dart';
import '../../services/device_service/device_session_api_service.dart';

class DeviceSessionController extends GetxController
    with WidgetsBindingObserver {
  final DeviceSessionApiService deviceSessionApiService;

  DeviceSessionController({
    required this.deviceSessionApiService,
  });

  final RxList<DeviceSessionModel> sessions =
      <DeviceSessionModel>[].obs;

  final Rxn<DeviceSessionModel> currentSession =
  Rxn<DeviceSessionModel>();

  final RxBool isLoading = false.obs;
  final RxBool isRegistering = false.obs;
  final RxBool isTerminating = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  Timer? _heartbeatTimer;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    initializeDeviceSession();
  }

  @override
  void onClose() {
    _heartbeatTimer?.cancel();

    WidgetsBinding.instance.removeObserver(this);

    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    if (state == AppLifecycleState.resumed) {
      sendHeartbeat();
      loadSessions();
    }
  }

  Future<void> initializeDeviceSession() async {
    try {
      isRegistering.value = true;
      errorMessage.value = '';

      final session = await deviceSessionApiService
          .registerCurrentDevice();

      currentSession.value = session;

      await loadSessions();

      _startHeartbeat();
    } catch (error) {
      errorMessage.value = _errorText(error);
    } finally {
      isRegistering.value = false;
    }
  }

  Future<void> loadSessions() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await deviceSessionApiService
          .getDeviceSessions();

      sessions.assignAll(result);

      final current = result.firstWhereOrNull(
            (session) => session.isCurrent,
      );

      if (current != null) {
        currentSession.value = current;
      }
    } catch (error) {
      errorMessage.value = _errorText(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendHeartbeat() async {
    try {
      final session =
      await deviceSessionApiService.sendHeartbeat();

      currentSession.value = session;

      _replaceSession(session);
    } catch (_) {
      // Do not show a UI error for a temporary background
      // heartbeat/network failure.
    }
  }

  Future<bool> terminateSession(
      DeviceSessionModel session,
      ) async {
    if (session.isCurrent) {
      errorMessage.value =
      'Use logout to terminate this device.';
      return false;
    }

    try {
      isTerminating.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final message = await deviceSessionApiService
          .terminateSession(session.id);

      sessions.removeWhere(
            (item) => item.id == session.id,
      );

      successMessage.value = message;

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isTerminating.value = false;
    }
  }

  Future<bool> terminateOtherSessions() async {
    try {
      isTerminating.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final count = await deviceSessionApiService
          .terminateOtherSessions();

      sessions.removeWhere(
            (session) => !session.isCurrent,
      );

      successMessage.value =
      '$count other device session(s) terminated.';

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isTerminating.value = false;
    }
  }

  Future<void> refreshSessions() {
    return loadSessions();
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();

    _heartbeatTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) {
        sendHeartbeat();
      },
    );
  }

  void _replaceSession(
      DeviceSessionModel updatedSession,
      ) {
    final index = sessions.indexWhere(
          (session) => session.id == updatedSession.id,
    );

    if (index >= 0) {
      sessions[index] = updatedSession;
    }
  }

  String _errorText(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('FormatException: ', '');
  }
}