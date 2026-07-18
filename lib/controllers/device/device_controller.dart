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

  List<DeviceSessionModel>
  get otherSessions {
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

    bool confirmed =
    await _showConfirmationDialog(
      title: 'Terminate session?',
      message:
      '${session.deviceName} will be logged out from your account.',
      confirmText: 'Terminate',
    );

    if (!confirmed) {
      return;
    }

    try {
      errorMessage.value = '';

      List<DeviceSessionModel> result =
      await deviceService
          .terminateSession(
        session.id,
      );

      sessions.assignAll(result);

      Get.snackbar(
        'Session terminated',
        '${session.deviceName} was logged out.',
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
        'Unable to terminate session',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  Future<void>
  terminateAllOtherSessions() async {
    if (otherSessions.isEmpty ||
        isTerminatingAll.value) {
      return;
    }

    bool confirmed =
    await _showConfirmationDialog(
      title: 'Terminate all sessions?',
      message:
      'All devices except this device will be logged out.',
      confirmText: 'Terminate all',
    );

    if (!confirmed) {
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
        'Sessions terminated',
        'All other devices were logged out.',
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
        'Unable to terminate sessions',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 16,
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
      await deviceService
          .resetSessions();

      sessions.assignAll(result);
    } catch (error) {
      errorMessage.value =
          _cleanErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
  }) async {
    BuildContext? context = Get.context;

    if (context == null) {
      return false;
    }

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    bool? result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(22),
        ),
        titlePadding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          8,
        ),
        contentPadding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          16,
        ),
        actionsPadding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.error
                    .withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: colorScheme.error,
                size: 21,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme
                    .textTheme.titleMedium
                    ?.copyWith(
                  color:
                  colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: theme.textTheme.bodyMedium
              ?.copyWith(
            color:
            colorScheme.onSurfaceVariant,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(
                result: false,
              );
            },
            child: Text(
              'Cancel',
            ),
          ),
          FilledButton(
            onPressed: () {
              Get.back(
                result: true,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor:
              colorScheme.error,
              foregroundColor:
              colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(13),
              ),
            ),
            child: Text(
              confirmText,
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    return result == true;
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