import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/data_storage_controller.dart';
import '../../widgets/data_storage/data_storage_confirmation_dialog.dart';
import '../../widgets/data_storage/data_storage_content.dart';
import '../../widgets/data_storage/media_quality_sheet.dart';
import 'data_storage_app_bar.dart';

class DataStorageScreen extends StatelessWidget {
  DataStorageScreen({
    super.key,
  });

  DataStorageController get controller {
    return Get.find<DataStorageController>();
  }

  Future<void> _openMediaQuality(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String? result = await MediaQualitySheet.open(
      context: context,
      selectedValue: controller.mediaQuality.value,
    );

    if (result == null) {
      return;
    }

    controller.changeMediaQuality(result);
  }

  Future<void> _openKeepMediaDuration(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    Map<String, String> optionLabels = {
      '3 days': 'three_days'.tr,
      '1 week': 'one_week'.tr,
      '1 month': 'one_month'.tr,
      'Forever': 'forever'.tr,
    };

    String currentValue =
        controller.keepMediaDuration.value;

    String selectedLabel =
        optionLabels[currentValue] ??
            currentValue;

    String? result = await MediaQualitySheet.open(
      context: context,
      title: 'keep_media'.tr,
      selectedValue: selectedLabel,
      options: optionLabels.values.toList(),
    );

    if (result == null) {
      return;
    }

    String storedValue = optionLabels.entries
        .firstWhere(
          (MapEntry<String, String> entry) {
        return entry.value == result;
      },
      orElse: () {
        return MapEntry(
          result,
          result,
        );
      },
    )
        .key;

    controller.changeKeepMediaDuration(
      storedValue,
    );
  }

  Future<void> _clearCache(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool confirmed =
    await AppConfirmationDialog.show(
      context: context,
      title: 'clear_cache_title'.tr,
      message: 'clear_cache_confirmation'.trParams({
        'size': controller.formattedCacheSize,
      }),
      confirmText: 'clear_cache'.tr,
      icon: Icons.cleaning_services_rounded,
      isDanger: true,
    );

    if (!confirmed) {
      return;
    }

    try {
      await controller.clearCache();

      if (!context.mounted) {
        return;
      }

      _showMessage(
        title: 'cache_cleared'.tr,
        message: 'cache_cleared_successfully'.tr,
        icon: Icons.check_circle_outline_rounded,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        title: 'unable_to_clear_cache'.tr,
        message: _cleanErrorMessage(error),
        icon: Icons.error_outline_rounded,
      );
    }
  }

  Future<void> _resetNetworkUsage(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await controller.resetNetworkUsage();

      if (!context.mounted) {
        return;
      }

      _showMessage(
        title: 'network_usage_reset'.tr,
        message:
        'network_usage_reset_successfully'.tr,
        icon: Icons.restart_alt_rounded,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        title:
        'unable_to_reset_network_usage'.tr,
        message: _cleanErrorMessage(error),
        icon: Icons.error_outline_rounded,
      );
    }
  }

  void _showMessage({
    required String title,
    required String message,
    required IconData icon,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 16,
      icon: Icon(
        icon,
      ),
      duration: Duration(
        seconds: 3,
      ),
      isDismissible: true,
      dismissDirection:
      DismissDirection.horizontal,
    );
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: DataStorageAppBar(),
      body: Obx(
            () {
          return DataStorageContent(
            cacheSize:
            controller.formattedCacheSize,
            networkUsage:
            controller.formattedNetworkUsage,
            mediaQuality:
            controller.mediaQuality.value,
            keepMediaDuration:
            controller.keepMediaDuration.value,
            autoDownloadMobileData:
            controller
                .autoDownloadMobileData.value,
            autoDownloadWifi:
            controller.autoDownloadWifi.value,
            autoDownloadRoaming:
            controller
                .autoDownloadRoaming.value,
            saveToGallery:
            controller.saveToGallery.value,
            streamVideos:
            controller.streamVideos.value,
            dataSaverEnabled:
            controller.dataSaverEnabled.value,
            isClearingCache:
            controller.isClearingCache.value,
            isResettingNetwork:
            controller
                .isResettingNetwork.value,
            onMobileDataChanged:
            controller
                .toggleMobileDataDownload,
            onWifiChanged:
            controller.toggleWifiDownload,
            onRoamingChanged:
            controller
                .toggleRoamingDownload,
            onSaveToGalleryChanged:
            controller.toggleSaveToGallery,
            onStreamVideosChanged:
            controller.toggleStreamVideos,
            onDataSaverChanged:
            controller.toggleDataSaver,
            onMediaQualityTap: () {
              _openMediaQuality(context);
            },
            onKeepMediaTap: () {
              _openKeepMediaDuration(context);
            },
            onClearCacheTap: () {
              _clearCache(context);
            },
            onResetNetworkTap: () {
              _resetNetworkUsage(context);
            },
          );
        },
      ),
    );
  }
}