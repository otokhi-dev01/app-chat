import 'package:get/get.dart';

class DataStorageController extends GetxController {
  final RxBool autoDownloadMobileData = true.obs;
  final RxBool autoDownloadWifi = true.obs;
  final RxBool autoDownloadRoaming = false.obs;

  final RxBool saveToGallery = false.obs;
  final RxBool streamVideos = true.obs;
  final RxBool dataSaverEnabled = false.obs;

  final RxString mediaQuality = 'Balanced'.obs;
  final RxString keepMediaDuration = '1 month'.obs;

  final RxDouble cacheSizeMb = 428.6.obs;
  final RxDouble networkUsageMb = 1284.4.obs;

  final RxBool isClearingCache = false.obs;
  final RxBool isResettingNetwork = false.obs;

  String get formattedCacheSize {
    double value = cacheSizeMb.value;

    if (value >= 1024) {
      return '${(value / 1024).toStringAsFixed(1)} GB';
    }

    return '${value.toStringAsFixed(1)} MB';
  }

  String get formattedNetworkUsage {
    double value = networkUsageMb.value;

    if (value >= 1024) {
      return '${(value / 1024).toStringAsFixed(1)} GB';
    }

    return '${value.toStringAsFixed(1)} MB';
  }

  void toggleMobileDataDownload(
      bool value,
      ) {
    if (autoDownloadMobileData.value == value) {
      return;
    }

    autoDownloadMobileData.value = value;
  }

  void toggleWifiDownload(
      bool value,
      ) {
    if (autoDownloadWifi.value == value) {
      return;
    }

    autoDownloadWifi.value = value;
  }

  void toggleRoamingDownload(
      bool value,
      ) {
    if (autoDownloadRoaming.value == value) {
      return;
    }

    autoDownloadRoaming.value = value;
  }

  void toggleSaveToGallery(
      bool value,
      ) {
    if (saveToGallery.value == value) {
      return;
    }

    saveToGallery.value = value;
  }

  void toggleStreamVideos(
      bool value,
      ) {
    if (streamVideos.value == value) {
      return;
    }

    streamVideos.value = value;
  }

  void toggleDataSaver(
      bool value,
      ) {
    if (dataSaverEnabled.value == value) {
      return;
    }

    dataSaverEnabled.value = value;
  }

  void changeMediaQuality(
      String value,
      ) {
    if (mediaQuality.value == value) {
      return;
    }

    mediaQuality.value = value;
  }

  void changeKeepMediaDuration(
      String value,
      ) {
    if (keepMediaDuration.value == value) {
      return;
    }

    keepMediaDuration.value = value;
  }

  Future<void> clearCache() async {
    if (isClearingCache.value) {
      return;
    }

    isClearingCache.value = true;

    try {
      await Future.delayed(
        Duration(
          milliseconds: 700,
        ),
      );

      cacheSizeMb.value = 0;
    } finally {
      isClearingCache.value = false;
    }
  }

  Future<void> resetNetworkUsage() async {
    if (isResettingNetwork.value) {
      return;
    }

    isResettingNetwork.value = true;

    try {
      await Future.delayed(
        Duration(
          milliseconds: 500,
        ),
      );

      networkUsageMb.value = 0;
    } finally {
      isResettingNetwork.value = false;
    }
  }
}