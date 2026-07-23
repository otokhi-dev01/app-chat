import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/device_session_model.dart';

class DeviceSessionTile extends StatelessWidget {
  final DeviceSessionModel session;
  final VoidCallback? onTerminate;

  DeviceSessionTile({
    super.key,
    required this.session,
    this.onTerminate,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: session.isCurrent
                ? colorScheme.primary.withValues(
              alpha: 0.25,
            )
                : borderColor,
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _DevicePlatformIcon(
              platform: session.platform,
              isCurrent: session.isCurrent,
            ),

            SizedBox(width: 13),

            Expanded(
              child: _DeviceSessionInformation(
                session: session,
              ),
            ),

            if (!session.isCurrent)
              _DeviceSessionMenu(
                onTerminate: onTerminate,
              ),
          ],
        ),
      ),
    );
  }
}

class _DevicePlatformIcon extends StatelessWidget {
  final DevicePlatform platform;
  final bool isCurrent;

  _DevicePlatformIcon({
    required this.platform,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: isCurrent ? 0.15 : 0.10,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: isCurrent ? 0.24 : 0.12,
          ),
        ),
      ),
      child: Icon(
        _platformIcon(platform),
        color: colorScheme.primary,
        size: 25,
      ),
    );
  }

  IconData _platformIcon(
      DevicePlatform platform,
      ) {
    switch (platform) {
      case DevicePlatform.ios:
        return Icons.phone_iphone_rounded;

      case DevicePlatform.android:
        return Icons.android_rounded;

      case DevicePlatform.macos:
        return Icons.laptop_mac_rounded;

      case DevicePlatform.windows:
        return Icons.desktop_windows_rounded;

      case DevicePlatform.linux:
        return Icons.computer_rounded;

      case DevicePlatform.web:
        return Icons.language_rounded;

      case DevicePlatform.unknown:
        return Icons.devices_other_rounded;
    }
  }
}

class _DeviceSessionInformation extends StatelessWidget {
  final DeviceSessionModel session;

  _DeviceSessionInformation({
    required this.session,
  });

  String _platformText(
      DevicePlatform platform,
      ) {
    switch (platform) {
      case DevicePlatform.ios:
        return 'platform_ios'.tr;

      case DevicePlatform.android:
        return 'platform_android'.tr;

      case DevicePlatform.macos:
        return 'platform_macos'.tr;

      case DevicePlatform.windows:
        return 'platform_windows'.tr;

      case DevicePlatform.linux:
        return 'platform_linux'.tr;

      case DevicePlatform.web:
        return 'platform_web'.tr;

      case DevicePlatform.unknown:
        return 'platform_unknown'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                session.deviceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            if (session.isCurrent) ...[
              SizedBox(width: 8),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  'current_device'.tr,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),

        SizedBox(height: 5),

        Text(
          '${_platformText(session.platform)} • ${session.appVersion}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 8),

        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 14,
            ),

            SizedBox(width: 5),

            Expanded(
              child: Text(
                session.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 5),

        Row(
          children: [
            Icon(
              Icons.language_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 14,
            ),

            SizedBox(width: 5),

            Expanded(
              child: Text(
                session.ipAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        _DeviceActivityStatus(
          session: session,
        ),
      ],
    );
  }
}

class _DeviceActivityStatus extends StatelessWidget {
  final DeviceSessionModel session;

  _DeviceActivityStatus({
    required this.session,
  });

  String _activityText() {
    if (session.isCurrent) {
      return 'active_now'.tr;
    }

    if (session.isOnline) {
      return 'online'.tr;
    }

    return session.lastActiveText;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    bool active =
        session.isCurrent || session.isOnline;

    Color statusColor = active
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),

        SizedBox(width: 6),

        Text(
          _activityText(),
          style: TextStyle(
            color: statusColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DeviceSessionMenu extends StatelessWidget {
  final VoidCallback? onTerminate;

  _DeviceSessionMenu({
    this.onTerminate,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      tooltip: 'session_options'.tr,
      padding: EdgeInsets.zero,
      color: theme.brightness == Brightness.dark
          ? Color(0xFF1B1D22)
          : Colors.white,
      surfaceTintColor: Colors.transparent,
      icon: Icon(
        Icons.more_vert_rounded,
        color: colorScheme.onSurfaceVariant,
        size: 21,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (String value) {
        if (value == 'terminate') {
          onTerminate?.call();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'terminate',
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(
                      alpha: 0.09,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: colorScheme.error,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'terminate_session'.tr,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}