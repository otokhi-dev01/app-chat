import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data_storage_card.dart';
import 'data_storage_title.dart';

class DataStorageContent extends StatelessWidget {
  final String cacheSize;
  final String networkUsage;
  final String mediaQuality;
  final String keepMediaDuration;

  final bool autoDownloadMobileData;
  final bool autoDownloadWifi;
  final bool autoDownloadRoaming;
  final bool saveToGallery;
  final bool streamVideos;
  final bool dataSaverEnabled;
  final bool isClearingCache;
  final bool isResettingNetwork;

  final ValueChanged<bool> onMobileDataChanged;
  final ValueChanged<bool> onWifiChanged;
  final ValueChanged<bool> onRoamingChanged;
  final ValueChanged<bool> onSaveToGalleryChanged;
  final ValueChanged<bool> onStreamVideosChanged;
  final ValueChanged<bool> onDataSaverChanged;

  final VoidCallback onMediaQualityTap;
  final VoidCallback onKeepMediaTap;
  final VoidCallback onClearCacheTap;
  final VoidCallback onResetNetworkTap;

  DataStorageContent({
    super.key,
    required this.cacheSize,
    required this.networkUsage,
    required this.mediaQuality,
    required this.keepMediaDuration,
    required this.autoDownloadMobileData,
    required this.autoDownloadWifi,
    required this.autoDownloadRoaming,
    required this.saveToGallery,
    required this.streamVideos,
    required this.dataSaverEnabled,
    required this.isClearingCache,
    required this.isResettingNetwork,
    required this.onMobileDataChanged,
    required this.onWifiChanged,
    required this.onRoamingChanged,
    required this.onSaveToGalleryChanged,
    required this.onStreamVideosChanged,
    required this.onDataSaverChanged,
    required this.onMediaQualityTap,
    required this.onKeepMediaTap,
    required this.onClearCacheTap,
    required this.onResetNetworkTap,
  });

  String _translatedMediaQuality(String value) {
    switch (value.trim().toLowerCase()) {
      case 'data saver':
        return 'data_saver'.tr;

      case 'balanced':
        return 'balanced'.tr;

      case 'high quality':
        return 'high_quality'.tr;

      case 'low':
        return 'quality_low'.tr;

      case 'medium':
        return 'quality_medium'.tr;

      case 'high':
        return 'quality_high'.tr;

      case 'original':
        return 'quality_original'.tr;

      default:
        return value;
    }
  }

  String _translatedKeepMediaDuration(String value) {
    switch (value.trim().toLowerCase()) {
      case '3 days':
        return 'three_days'.tr;

      case '1 week':
        return 'one_week'.tr;

      case '1 month':
        return 'one_month'.tr;

      case 'forever':
        return 'forever'.tr;

      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        18,
        16,
        34,
      ),
      children: [
        DataStorageSummaryCard(
          cacheSize: cacheSize,
          networkUsage: networkUsage,
        ),

        SizedBox(height: 24),

        DataStorageSectionTitle(
          title: 'storage'.tr,
        ),

        SizedBox(height: 9),

        DataStorageCard(
          children: [
            DataStorageActionTile(
              icon: Icons.cleaning_services_outlined,
              title: 'clear_cache'.tr,
              subtitle: 'clear_cache_description'.tr,
              trailingText: cacheSize,
              loading: isClearingCache,
              onTap: onClearCacheTap,
            ),

            DataStorageDivider(),

            DataStorageNavigationTile(
              icon: Icons.access_time_rounded,
              title: 'keep_media'.tr,
              subtitle: 'keep_media_description'.tr,
              trailingText: _translatedKeepMediaDuration(
                keepMediaDuration,
              ),
              onTap: onKeepMediaTap,
            ),
          ],
        ),

        SizedBox(height: 24),

        DataStorageSectionTitle(
          title: 'automatic_media_download'.tr,
        ),

        SizedBox(height: 9),

        DataStorageCard(
          children: [
            DataStorageSwitchTile(
              icon: Icons.signal_cellular_alt_rounded,
              title: 'using_mobile_data'.tr,
              subtitle: 'mobile_data_download_description'.tr,
              value: autoDownloadMobileData,
              onChanged: onMobileDataChanged,
            ),

            DataStorageDivider(),

            DataStorageSwitchTile(
              icon: Icons.wifi_rounded,
              title: 'connected_to_wifi'.tr,
              subtitle: 'wifi_download_description'.tr,
              value: autoDownloadWifi,
              onChanged: onWifiChanged,
            ),

            DataStorageDivider(),

            DataStorageSwitchTile(
              icon: Icons.public_rounded,
              title: 'while_roaming'.tr,
              subtitle: 'roaming_download_description'.tr,
              value: autoDownloadRoaming,
              onChanged: onRoamingChanged,
            ),
          ],
        ),

        SizedBox(height: 24),

        DataStorageSectionTitle(
          title: 'media'.tr,
        ),

        SizedBox(height: 9),

        DataStorageCard(
          children: [
            DataStorageNavigationTile(
              icon: Icons.high_quality_outlined,
              title: 'media_quality'.tr,
              subtitle: 'media_quality_description'.tr,
              trailingText: _translatedMediaQuality(
                mediaQuality,
              ),
              onTap: onMediaQualityTap,
            ),

            DataStorageDivider(),

            DataStorageSwitchTile(
              icon: Icons.play_circle_outline_rounded,
              title: 'stream_videos'.tr,
              subtitle: 'stream_videos_description'.tr,
              value: streamVideos,
              onChanged: onStreamVideosChanged,
            ),

            DataStorageDivider(),

            DataStorageSwitchTile(
              icon: Icons.photo_library_outlined,
              title: 'save_to_gallery'.tr,
              subtitle: 'save_to_gallery_description'.tr,
              value: saveToGallery,
              onChanged: onSaveToGalleryChanged,
            ),
          ],
        ),

        SizedBox(height: 24),

        DataStorageSectionTitle(
          title: 'data_usage'.tr,
        ),

        SizedBox(height: 9),

        DataStorageCard(
          children: [
            DataStorageSwitchTile(
              icon: Icons.data_saver_on_rounded,
              title: 'data_saver'.tr,
              subtitle: 'data_saver_description'.tr,
              value: dataSaverEnabled,
              onChanged: onDataSaverChanged,
            ),

            DataStorageDivider(),

            DataStorageActionTile(
              icon: Icons.restart_alt_rounded,
              title: 'reset_network_usage'.tr,
              subtitle: 'reset_network_usage_description'.tr,
              trailingText: networkUsage,
              loading: isResettingNetwork,
              onTap: onResetNetworkTap,
            ),
          ],
        ),

        SizedBox(height: 18),

        DataStorageInformationCard(),
      ],
    );
  }
}