import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/device/device_controller.dart';
import '../../../services/device_service.dart';
import '../../../services/mock/mock_device_service.dart';
import '../../widgets/device/device_content.dart';
import '../../widgets/device/device_state_view.dart';
import 'device_app_bar.dart';

class DevicesScreen extends StatelessWidget {
  DevicesScreen({
    super.key,
  });

  DeviceController get controller {
    if (!Get.isRegistered<DeviceService>()) {
      Get.put<DeviceService>(
        MockDeviceService(),
        permanent: true,
      );
    }

    if (Get.isRegistered<DeviceController>()) {
      return Get.find<DeviceController>();
    }

    return Get.put<DeviceController>(
      DeviceController(
        deviceService:
        Get.find<DeviceService>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: DevicesAppBar(
        controller: controller,
      ),
      body: Obx(
            () {
          bool isInitialLoading =
              controller.isLoading.value &&
                  controller.sessions.isEmpty;

          if (isInitialLoading) {
            return DevicesLoadingView();
          }

          bool hasInitialError =
              controller
                  .errorMessage.value.isNotEmpty &&
                  controller.sessions.isEmpty;

          if (hasInitialError) {
            return DevicesErrorView(
              message:
              controller.errorMessage.value,
              onRetry:
              controller.loadSessions,
            );
          }

          return DevicesContent(
            currentSession:
            controller.currentSession,
            otherSessions:
            controller.otherSessions,
            isTerminatingAll:
            controller
                .isTerminatingAll.value,
            onRefresh:
            controller.refreshSessions,
            onTerminate:
            controller.terminateSession,
            onTerminateAll:
            controller
                .terminateAllOtherSessions,
          );
        },
      ),
    );
  }
}