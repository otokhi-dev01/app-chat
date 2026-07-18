import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import '../../../route/app_route.dart';

class GeneralSettingsSection extends StatelessWidget {
  final SettingsController controller;

  GeneralSettingsSection({
    super.key,
    required this.controller,
  });

  void _openRoute(
      String route,
      ) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Get.currentRoute == route) {
      return;
    }

    Get.toNamed(
      route,
      preventDuplicates: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color dividerColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'general'.tr,
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: Column(
            children: [
              Obx(
                    () {
                  return _SwitchSettingsTile(
                    icon:
                    Icons.notifications_outlined,
                    title: 'notifications'.tr,
                    subtitle:
                    'enable_notifications'.tr,
                    value: controller
                        .notificationsEnabled.value,
                    onChanged:
                    controller.toggleNotifications,
                  );
                },
              ),
              _SettingsDivider(
                color: dividerColor,
              ),
              _NavigationSettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'privacy_security'.tr,
                subtitle: 'manage_privacy'.tr,
                onTap: () {
                  FocusManager.instance.primaryFocus
                      ?.unfocus();

                  Get.toNamed(
                    AppRoutes.privacySecurity,
                    preventDuplicates: true,
                  );
                },
              ),
              _SettingsDivider(
                color: dividerColor,
              ),
              _NavigationSettingsTile(
                icon: Icons.folder_open_outlined,
                title: 'chat_folders'.tr,
                subtitle: 'manage_folders'.tr,
                onTap: () {
                  FocusManager.instance.primaryFocus
                      ?.unfocus();

                  Get.toNamed(
                    AppRoutes.chatFolders,
                    preventDuplicates: true,
                  );
                },
              ),
              _SettingsDivider(
                color: dividerColor,
              ),
              _NavigationSettingsTile(
                icon:
                Icons.devices_outlined,
                title: 'devices'.tr,
                subtitle:
                'manage_devices'.tr,
                onTap: () {
                  _openRoute(
                    AppRoutes.devices,
                  );
                },
              ),
              _SettingsDivider(
                color: dividerColor,
              ),
              _NavigationSettingsTile(
                icon: Icons.storage_outlined,
                title: 'data_storage'.tr,
                subtitle: 'manage_storage'.tr,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  Get.toNamed(
                    AppRoutes.dataStorage,
                    preventDuplicates: true,
                  );
                },
              ),
              _SettingsDivider(
                color: dividerColor,
              ),
              _NavigationSettingsTile(
                icon:
                Icons.info_outline_rounded,
                title: 'about_app'.tr,
                subtitle:
                'version_information'.tr,
                onTap: () {
                  _openRoute(
                    AppRoutes.about,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchSettingsTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  _SwitchSettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return _SmoothSettingsTile(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 180,
        ),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        color: value
            ? colorScheme.primary.withValues(
          alpha: 0.06,
        )
            : Colors.transparent,
        child: Row(
          children: [
            _SettingsIcon(
              icon: icon,
              active: value,
            ),
            SizedBox(width: 13),
            Expanded(
              child: _SettingsTileText(
                title: title,
                subtitle: subtitle,
                active: value,
              ),
            ),
            SizedBox(width: 10),

            // Ignore direct switch taps so the value
            // changes only once through the tile.
            IgnorePointer(
              child: Switch.adaptive(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationSettingsTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  _NavigationSettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return _SmoothSettingsTile(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            _SettingsIcon(
              icon: icon,
            ),
            SizedBox(width: 13),
            Expanded(
              child: _SettingsTileText(
                title: title,
                subtitle: subtitle,
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
              SizedBox(width: 5),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme
                  .onSurfaceVariant,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}

class _SmoothSettingsTile
    extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  _SmoothSettingsTile({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark =
        theme.brightness == Brightness.dark;

    Color pressedColor = isDark
        ? Colors.white.withValues(
      alpha: 0.055,
    )
        : Colors.black.withValues(
      alpha: 0.035,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory:
        InkRipple.splashFactory,
        highlightColor:
        Colors.transparent,
        hoverColor:
        Colors.transparent,
        focusColor:
        Colors.transparent,
        overlayColor:
        WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(
              WidgetState.pressed,
            ) ||
                states.contains(
                  WidgetState.focused,
                )) {
              return pressedColor;
            }

            return Colors.transparent;
          },
        ),
        child: child,
      ),
    );
  }
}

class _SettingsIcon
    extends StatelessWidget {
  final IconData icon;
  final bool active;

  _SettingsIcon({
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: Duration(
        milliseconds: 180,
      ),
      curve: Curves.easeOutCubic,
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? colorScheme.primary.withValues(
          alpha: 0.16,
        )
            : colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        size: 22,
        color: active
            ? colorScheme.primary
            : colorScheme
            .onSurfaceVariant,
      ),
    );
  }
}

class _SettingsTileText
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;

  _SettingsTileText({
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: Duration(
            milliseconds: 180,
          ),
          curve: Curves.easeOutCubic,
          style: theme.textTheme.bodyLarge
              ?.copyWith(
            color: active
                ? colorScheme.primary
                : colorScheme.onSurface,
            fontWeight: active
                ? FontWeight.w700
                : FontWeight.w600,
          ) ??
              TextStyle(
                color: active
                    ? colorScheme.primary
                    : colorScheme.onSurface,
                fontWeight: active
                    ? FontWeight.w700
                    : FontWeight.w600,
              ),
          child: Text(
            title,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall
              ?.copyWith(
            color: colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SettingsDivider
    extends StatelessWidget {
  final Color color;

  _SettingsDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 69,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }
}

class _SectionTitle
    extends StatelessWidget {
  final String title;

  _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall
            ?.copyWith(
          color:
          theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}