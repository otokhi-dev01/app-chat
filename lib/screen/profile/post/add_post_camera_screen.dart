import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profile/add_post_camera_controller.dart';
import '../../widgets/post/add_post_camera_controls.dart';
import '../../widgets/post/add_post_camera_preview.dart';
import 'add_post_camera_top_bar.dart';

class AddPostCameraScreen
    extends GetView<AddPostCameraController> {
  AddPostCameraScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Obx(
                () {
              return AddPostCameraPreview(
                controller:
                controller.camera.value,
                loading: controller
                    .isInitializing.value,
                showGrid:
                controller.showGrid.value,
                errorMessage: controller
                    .errorMessage.value,
                onRetry:
                controller.initializeCamera,
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(
                  () {
                return AddPostCameraTopBar(
                  flashMode:
                  controller.flashMode.value,
                  gridEnabled:
                  controller.showGrid.value,
                  recording:
                  controller.isRecording.value,
                  onBack:
                  controller.closeCamera,
                  onFlash:
                  controller.cycleFlash,
                  onGrid:
                  controller.toggleGrid,
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
                  () {
                return AddPostCameraControls(
                  selectedMode: controller
                      .selectedMode.value,
                  recording: controller
                      .isRecording.value,
                  busy:
                  controller.isBusy.value,
                  canSwitchCamera: controller
                      .hasMultipleCameras,
                  onGallery:
                  controller.openGallery,
                  onCapture:
                  controller.capture,
                  onSwitchCamera:
                  controller.switchCamera,
                  onModeChanged:
                  controller.changeMode,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}