import 'package:appchat/screen/profile/qr_code/profile_qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/settings/settings_controller.dart';
import '../../data/mock_profile_story_post_data.dart';
import '../../models/profile_story_post_model.dart';
import '../../route/app_route.dart';
import '../widgets/story/profile_post_viewer_screen.dart';
import '../widgets/story/profile_story_post_section.dart';
import '../widgets/settings/account_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
  });

  String _firstLetter(
      String name,
      ) {
    String value = name.trim();

    if (value.isEmpty) {
      return '?';
    }

    return value.substring(
      0,
      1,
    ).toUpperCase();
  }

  void _openEditProfile() {
    FocusManager.instance.primaryFocus?.unfocus();

    Get.toNamed(
      AppRoutes.editProfile,
    );
  }

  void _copyUsername(
      BuildContext context,
      String username,
      ) {
    String value = username.trim();

    if (value.isEmpty) {
      _showMessage(
        context: context,
        message: 'Username is unavailable',
        isError: true,
      );

      return;
    }

    Clipboard.setData(
      ClipboardData(
        text: value,
      ),
    );

    _showMessage(
      context: context,
      message: 'Username copied to clipboard',
    );
  }

  void _showMessage({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    Color backgroundColor = isError
        ? colorScheme.error
        : colorScheme.primary;

    Color foregroundColor = isError
        ? colorScheme.onError
        : colorScheme.onPrimary;

    Get.rawSnackbar(
      messageText: Row(
        children: [
          Icon(
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: foregroundColor,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      borderRadius: 14,
      margin: EdgeInsets.all(14),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(
        milliseconds: 1500,
      ),
    );
  }

  void _openQrCode({
    required String name,
    required String username,
  }) {
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
  }

  void _openPost(
      ProfilePostItem post,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    Get.to(
          () => ProfilePostViewerScreen(
        post: post,
      ),
      transition: Transition.fadeIn,
      duration: Duration(
        milliseconds: 220,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsController controller =
    Get.find<SettingsController>();

    ThemeData theme =
    Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pageColor =
        theme.scaffoldBackgroundColor;

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

    return ColoredBox(
      color: pageColor,
      child: Obx(
            () {
          String name =
          controller.userName.value.trim();

          String email =
          controller.userEmail.value.trim();

          String username =
          controller.userUsername.value.trim();

          return ListView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior
                .onDrag,
            physics: BouncingScrollPhysics(
              parent:
              AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              14,
              16,
              14,
              110,
            ),
            children: [
              _ProfileHeaderCard(
                name: name,
                email: email,
                firstLetter:
                _firstLetter(name),
                cardColor: cardColor,
                borderColor: borderColor,
                onEdit: _openEditProfile,
                onCopyUsername: () {
                  _copyUsername(
                    context,
                    username,
                  );
                },
                onQrCode: () {
                  _openQrCode(
                    name: name,
                    username: username,
                  );
                },
              ),

              SizedBox(height: 22),

              AccountSettingsSection(
                controller: controller,
              ),

              SizedBox(height: 22),

              ProfileStoryPostSection(
                posts:
                MockProfileStoryPostData
                    .posts,
                onPostTap: (
                    ProfilePostItem post,
                    ) {
                  _openPost(
                    post,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeaderCard
    extends StatelessWidget {
  final String name;
  final String email;
  final String firstLetter;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onEdit;
  final VoidCallback onCopyUsername;
  final VoidCallback onQrCode;

  _ProfileHeaderCard({
    required this.name,
    required this.email,
    required this.firstLetter,
    required this.cardColor,
    required this.borderColor,
    required this.onEdit,
    required this.onCopyUsername,
    required this.onQrCode,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18,
        24,
        18,
        20,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.18 : 0.05,
            ),
            blurRadius: 20,
            offset: Offset(
              0,
              8,
            ),
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
                      .withValues(
                    alpha: 0.14,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary
                        .withValues(
                      alpha: 0.24,
                    ),
                    width: 2,
                  ),
                ),
                child: Text(
                  firstLetter,
                  style: TextStyle(
                    color:
                    colorScheme.primary,
                    fontSize: 38,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: 2,
                child: _ProfileTapButton(
                  onTap: onEdit,
                  circular: true,
                  child: Container(
                    width: 34,
                    height: 34,
                    alignment:
                    Alignment.center,
                    decoration: BoxDecoration(
                      color:
                      colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color:
                      colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            name.isEmpty
                ? 'Your Name'
                : name,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme
                .textTheme.titleLarge
                ?.copyWith(
              color:
              colorScheme.onSurface,
              fontSize: 23,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          SizedBox(height: 5),

          Text(
            email.isEmpty
                ? 'No email address'
                : email,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme
                .textTheme.bodyMedium
                ?.copyWith(
              color: colorScheme
                  .onSurfaceVariant,
              fontSize: 13,
              fontWeight:
              FontWeight.w500,
            ),
          ),

          SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _ProfileActionButton(
                  icon: Icons.edit_rounded,
                  label: 'Edit',
                  onTap: onEdit,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ProfileActionButton(
                  icon: Icons
                      .alternate_email_rounded,
                  label: 'Username',
                  onTap: onCopyUsername,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ProfileActionButton(
                  icon:
                  Icons.qr_code_rounded,
                  label: 'QR Code',
                  onTap: onQrCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileActionButton
    extends StatelessWidget {
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
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color backgroundColor = isDark
        ? Colors.white.withValues(
      alpha: 0.07,
    )
        : colorScheme.primary.withValues(
      alpha: 0.08,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.06,
    )
        : colorScheme.primary.withValues(
      alpha: 0.08,
    );

    return _ProfileTapButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              overflow:
              TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme.bodySmall
                  ?.copyWith(
                color:
                colorScheme.primary,
                fontSize: 11,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTapButton
    extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool circular;

  _ProfileTapButton({
    required this.child,
    required this.onTap,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: circular
          ? CircleBorder()
          : null,
      child: InkWell(
        onTap: onTap,
        customBorder: circular
            ? CircleBorder()
            : null,
        borderRadius: circular
            ? null
            : BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: child,
      ),
    );
  }
}