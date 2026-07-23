import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/device_session_model.dart';
import '../../services/device_service.dart';

class DeviceController extends GetxController {
  final DeviceService deviceService;

  DeviceController({
    required this.deviceService,
  });

  final RxList<DeviceSessionModel> sessions =
      <DeviceSessionModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isTerminatingAll = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadSessions();
  }

  DeviceSessionModel? get currentSession {
    int index = sessions.indexWhere(
          (DeviceSessionModel session) {
        return session.isCurrent;
      },
    );

    if (index < 0) {
      return null;
    }

    return sessions[index];
  }

  List<DeviceSessionModel> get otherSessions {
    return sessions.where(
          (DeviceSessionModel session) {
        return !session.isCurrent;
      },
    ).toList();
  }

  int get otherSessionCount {
    return otherSessions.length;
  }

  Future<void> loadSessions() async {
    await _fetchSessions();
  }

  Future<void> refreshSessions() async {
    await _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      List<DeviceSessionModel> result =
      await deviceService.getSessions();

      sessions.assignAll(result);
    } catch (error) {
      errorMessage.value =
          _cleanErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> terminateSession(
      DeviceSessionModel session,
      ) async {
    if (session.isCurrent) {
      return;
    }

    try {
      errorMessage.value = '';

      List<DeviceSessionModel> result =
      await deviceService.terminateSession(
        session.id,
      );

      sessions.assignAll(result);

      Get.snackbar(
        'session_terminated'.tr,
        'device_logged_out'.trParams({
          'device': session.deviceName,
        }),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 16,
        icon: Icon(
          Icons.logout_rounded,
        ),
      );
    } catch (error) {
      errorMessage.value =
          _cleanErrorMessage(error);

      Get.snackbar(
        'unable_to_terminate_session'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 16,
        icon: Icon(
          Icons.error_outline_rounded,
        ),
      );
    }
  }

  Future<void> terminateAllOtherSessions() async {
    if (otherSessions.isEmpty ||
        isTerminatingAll.value) {
      return;
    }

    try {
      isTerminatingAll.value = true;
      errorMessage.value = '';

      List<DeviceSessionModel> result =
      await deviceService
          .terminateAllOtherSessions();

      sessions.assignAll(result);

      Get.snackbar(
        'sessions_terminated'.tr,
        'all_other_devices_logged_out'.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 16,
        icon: Icon(
          Icons.verified_user_rounded,
        ),
      );
    } catch (error) {
      errorMessage.value =
          _cleanErrorMessage(error);

      Get.snackbar(
        'unable_to_terminate_sessions'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 16,
        icon: Icon(
          Icons.error_outline_rounded,
        ),
      );
    } finally {
      isTerminatingAll.value = false;
    }
  }

  Future<void> resetMockSessions() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      List<DeviceSessionModel> result =
      await deviceService.resetSessions();

      sessions.assignAll(result);
    } catch (error) {
      errorMessage.value =
          _cleanErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

  String _cleanErrorMessage(
      Object error,
      ) {
    return error
        .toString()
        .replaceFirst(
      'Bad state: ',
      '',
    )
        .replaceFirst(
      'Exception: ',
      '',
    );
  }
}