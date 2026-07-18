import 'package:flutter/material.dart';

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
          title: 'Storage',
        ),
        SizedBox(height: 9),
        DataStorageCard(
          children: [
            DataStorageActionTile(
              icon: Icons.cleaning_services_outlined,
              title: 'Clear Cache',
              subtitle: 'Remove temporary photos, videos and files',
              trailingText: cacheSize,
              loading: isClearingCache,
              onTap: onClearCacheTap,
            ),
            DataStorageDivider(),
            DataStorageNavigationTile(
              icon: Icons.access_time_rounded,
              title: 'Keep Media',
              subtitle: 'Choose how long downloaded media is stored',
              trailingText: keepMediaDuration,
              onTap: onKeepMediaTap,
            ),
          ],
        ),
        SizedBox(height: 24),
        DataStorageSectionTitle(
          title: 'Automatic Media Download',
        ),
        SizedBox(height: 9),
        DataStorageCard(
          children: [
            DataStorageSwitchTile(
              icon: Icons.signal_cellular_alt_rounded,
              title: 'Using Mobile Data',
              subtitle: 'Automatically download media on mobile data',
              value: autoDownloadMobileData,
              onChanged: onMobileDataChanged,
            ),
            DataStorageDivider(),
            DataStorageSwitchTile(
              icon: Icons.wifi_rounded,
              title: 'Connected to Wi-Fi',
              subtitle: 'Automatically download media on Wi-Fi',
              value: autoDownloadWifi,
              onChanged: onWifiChanged,
            ),
            DataStorageDivider(),
            DataStorageSwitchTile(
              icon: Icons.public_rounded,
              title: 'While Roaming',
              subtitle: 'Downloading while roaming may cost more',
              value: autoDownloadRoaming,
              onChanged: onRoamingChanged,
            ),
          ],
        ),
        SizedBox(height: 24),
        DataStorageSectionTitle(
          title: 'Media',
        ),
        SizedBox(height: 9),
        DataStorageCard(
          children: [
            DataStorageNavigationTile(
              icon: Icons.high_quality_outlined,
              title: 'Media Quality',
              subtitle: 'Choose upload and download quality',
              trailingText: mediaQuality,
              onTap: onMediaQualityTap,
            ),
            DataStorageDivider(),
            DataStorageSwitchTile(
              icon: Icons.play_circle_outline_rounded,
              title: 'Stream Videos',
              subtitle: 'Play videos without waiting for full download',
              value: streamVideos,
              onChanged: onStreamVideosChanged,
            ),
            DataStorageDivider(),
            DataStorageSwitchTile(
              icon: Icons.photo_library_outlined,
              title: 'Save to Gallery',
              subtitle: 'Save new photos and videos to your gallery',
              value: saveToGallery,
              onChanged: onSaveToGalleryChanged,
            ),
          ],
        ),
        SizedBox(height: 24),
        DataStorageSectionTitle(
          title: 'Data Usage',
        ),
        SizedBox(height: 9),
        DataStorageCard(
          children: [
            DataStorageSwitchTile(
              icon: Icons.data_saver_on_rounded,
              title: 'Data Saver',
              subtitle: 'Use less mobile data for calls and media',
              value: dataSaverEnabled,
              onChanged: onDataSaverChanged,
            ),
            DataStorageDivider(),
            DataStorageActionTile(
              icon: Icons.restart_alt_rounded,
              title: 'Reset Network Usage',
              subtitle: 'Reset sent and received data statistics',
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