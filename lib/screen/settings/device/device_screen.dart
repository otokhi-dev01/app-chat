import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/device/device_controller.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service /auth_api_service.dart';
import '../../../services/device_service/device_identity_service.dart';
import '../../../services/device_service/device_session_api_service.dart';
import 'device_content.dart';
import 'device_state_view.dart';
import 'device_app_bar.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({
    super.key,
  });

  DeviceSessionController get controller {
    if (!Get.isRegistered<DeviceIdentityService>()) {
      Get.lazyPut<DeviceIdentityService>(
        () => DeviceIdentityService(),
      );
    }

    if (!Get.isRegistered<DeviceSessionApiService>()) {
      Get.lazyPut<DeviceSessionApiService>(
        () => DeviceSessionApiService(
          apiService: Get.find<ApiService>(),
          authApiService: Get.find<AuthApiService>(),
          identityService: Get.find<DeviceIdentityService>(),
        ),
      );
    }

    if (Get.isRegistered<DeviceSessionController>()) {
      return Get.find<DeviceSessionController>();
    }

    return Get.put<DeviceSessionController>(
      DeviceSessionController(
        deviceSessionApiService: Get.find<DeviceSessionApiService>(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: DevicesAppBar(
        controller: controller,
      ),
      body: Obx(
            () {
          bool isInitialLoading =
              controller.isLoading.value && controller.sessions.isEmpty;

          if (isInitialLoading) {
            return DevicesLoadingView();
          }

          bool hasInitialError =
              controller.errorMessage.value.isNotEmpty &&
                  controller.sessions.isEmpty;

          if (hasInitialError) {
            return DevicesErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.loadSessions,
            );
          }

          return DevicesContent(
            currentSession: controller.currentSession.value,
            otherSessions: controller.sessions.where((s) => !s.isCurrent).toList(),
            isTerminatingAll: controller.isTerminating.value,
            onRefresh: controller.refreshSessions,
            onTerminate: controller.terminateSession,
            onTerminateAll: controller.terminateOtherSessions,
          );
        },
      ),
    );
  }
}