import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/data_storage_controller.dart';
import '../../widgets/data_storage/clear_cache_sheet.dart';
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

    controller.changeMediaQuality(
      result,
    );
  }

  Future<void> _openKeepMediaDuration(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String? result = await MediaQualitySheet.open(
      context: context,
      title: 'Keep Media',
      selectedValue: controller.keepMediaDuration.value,
      options: [
        '3 days',
        '1 week',
        '1 month',
        'Forever',
      ],
    );

    if (result == null) {
      return;
    }

    controller.changeKeepMediaDuration(
      result,
    );
  }

  Future<void> _clearCache(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool? confirmed = await ClearCacheSheet.open(
      context: context,
      cacheSize: controller.formattedCacheSize,
    );

    if (confirmed != true) {
      return;
    }

    await controller.clearCache();

    if (!context.mounted) {
      return;
    }

    _showMessage(
      context: context,
      message: 'Cache cleared successfully.',
      icon: Icons.check_circle_outline_rounded,
    );
  }

  Future<void> _resetNetworkUsage(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await controller.resetNetworkUsage();

    if (!context.mounted) {
      return;
    }

    _showMessage(
      context: context,
      message: 'Network usage statistics were reset.',
      icon: Icons.restart_alt_rounded,
    );
  }

  void _showMessage({
    required BuildContext context,
    required String message,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 21,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: DataStorageAppBar(),
      body: Obx(
            () {
          return DataStorageContent(
            cacheSize: controller.formattedCacheSize,
            networkUsage: controller.formattedNetworkUsage,
            mediaQuality: controller.mediaQuality.value,
            keepMediaDuration: controller.keepMediaDuration.value,
            autoDownloadMobileData:
            controller.autoDownloadMobileData.value,
            autoDownloadWifi:
            controller.autoDownloadWifi.value,
            autoDownloadRoaming:
            controller.autoDownloadRoaming.value,
            saveToGallery:
            controller.saveToGallery.value,
            streamVideos:
            controller.streamVideos.value,
            dataSaverEnabled:
            controller.dataSaverEnabled.value,
            isClearingCache:
            controller.isClearingCache.value,
            isResettingNetwork:
            controller.isResettingNetwork.value,
            onMobileDataChanged:
            controller.toggleMobileDataDownload,
            onWifiChanged:
            controller.toggleWifiDownload,
            onRoamingChanged:
            controller.toggleRoamingDownload,
            onSaveToGalleryChanged:
            controller.toggleSaveToGallery,
            onStreamVideosChanged:
            controller.toggleStreamVideos,
            onDataSaverChanged:
            controller.toggleDataSaver,
            onMediaQualityTap: () {
              _openMediaQuality(
                context,
              );
            },
            onKeepMediaTap: () {
              _openKeepMediaDuration(
                context,
              );
            },
            onClearCacheTap: () {
              _clearCache(
                context,
              );
            },
            onResetNetworkTap: () {
              _resetNetworkUsage(
                context,
              );
            },
          );
        },
      ),
    );
  }
}