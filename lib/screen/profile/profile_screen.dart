import 'package:appchat/screen/profile/profile_qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/settings_controller.dart';
import '../../route/app_route.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
  });

  String _firstLetter(String name) {
    String value = name.trim();

    if (value.isEmpty) {
      return '?';
    }

    return value[0].toUpperCase();
  }

  void _openEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  void _copyUsername(
      BuildContext context,
      String username,
      ) {
    String value = username.trim();

    if (value.isEmpty) {
      return;
    }

    Clipboard.setData(
      ClipboardData(text: value),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Username copied'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    SettingsController controller =
    Get.find<SettingsController>();

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Obx(
          () {
        String name = controller.userName.value.trim();
        String email = controller.userEmail.value.trim();
        String username =
        controller.userUsername.value.trim();
        String bio = controller.userBio.value.trim();

        return ListView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            14,
            16,
            14,
            110,
          ),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                18,
                24,
                18,
                20,
              ),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: borderColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.18 : 0.05,
                    ),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primary
                              .withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary
                                .withValues(alpha: 0.24),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _firstLetter(name),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: 2,
                        child: Material(
                          color: colorScheme.primary,
                          shape: CircleBorder(),
                          child: InkWell(
                            onTap: _openEditProfile,
                            customBorder: CircleBorder(),
                            child: SizedBox(
                              width: 34,
                              height: 34,
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: colorScheme.onPrimary,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  Text(
                    name.isEmpty ? 'Your Name' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    email.isEmpty
                        ? 'No email address'
                        : email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: _ProfileActionButton(
                          icon: Icons.edit_rounded,
                          label: 'Edit',
                          onTap: _openEditProfile,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _ProfileActionButton(
                          icon: Icons.alternate_email_rounded,
                          label: 'Username',
                          onTap: () {
                            _copyUsername(
                              context,
                              username,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _ProfileActionButton(
                          icon: Icons.qr_code_rounded,
                          label: 'QR Code',
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            Get.to(
                                  () => ProfileQrCodeScreen(
                                name: name,
                                username: username,
                              ),
                              transition: Transition.rightToLeft,
                              duration: Duration(
                                milliseconds: 280,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 22),

            _SectionTitle(
              title: 'profile_information'.tr,
            ),

            SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Column(
                children: [
                  _ProfileInfoTile(
                    icon: Icons.alternate_email_rounded,
                    title: username.isEmpty
                        ? 'No username'
                        : username.startsWith('@')
                        ? username
                        : '@$username',
                    subtitle: 'Username',
                    onTap: username.isEmpty
                        ? null
                        : () {
                      _copyUsername(
                        context,
                        username,
                      );
                    },
                  ),

                  _ProfileDivider(),

                  _ProfileInfoTile(
                    icon: Icons.email_outlined,
                    title: email.isEmpty
                        ? 'No email address'
                        : email,
                    subtitle: 'Email',
                  ),

                  _ProfileDivider(),

                  _ProfileInfoTile(
                    icon: Icons.info_outline_rounded,
                    title: bio.isEmpty
                        ? 'Add a short bio about yourself'
                        : bio,
                    subtitle: 'Bio',
                    maxLines: 3,
                    onTap: _openEditProfile,
                  ),
                ],
              ),
            ),

            SizedBox(height: 22),

            _SectionTitle(
              title: 'Account',
            ),

            SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Column(
                children: [
                  _ProfileMenuTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle:
                    'Messages, groups and calls',
                    onTap: () {},
                  ),

                  _ProfileDivider(),

                  _ProfileMenuTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacy and Security',
                    subtitle:
                    'Blocked users and permissions',
                    onTap: () {},
                  ),

                  _ProfileDivider(),

                  _ProfileMenuTile(
                    icon: Icons.storage_rounded,
                    title: 'Data and Storage',
                    subtitle:
                    'Storage usage and downloads',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    return Material(
      color: isDark
          ? Colors.white.withValues(alpha: 0.07)
          : colorScheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 13,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 22,
              ),
              SizedBox(height: 7),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 7,
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int maxLines;
  final VoidCallback? onTap;

  _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.maxLines = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            13,
            14,
            13,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 21,
                ),
              ),

              SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              if (onTap != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: 11,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.55),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            13,
            12,
            13,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 21,
                ),
              ),

              SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    return Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      endIndent: 14,
      color: isDark
          ? Colors.white.withValues(alpha: 0.07)
          : Colors.black.withValues(alpha: 0.055),
    );
  }
}