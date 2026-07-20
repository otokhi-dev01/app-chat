import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user/user_controller.dart';
import '../widgets/profile_detail/profile_detail_action.dart';
import '../widgets/profile_detail/profile_detail_app_bar.dart';
import '../widgets/profile_detail/profile_detail_header.dart';
import '../widgets/profile_detail/profile_detail_info_section.dart';
import '../widgets/profile_detail/profile_more_option_sheet.dart';

class ProfileDetailScreen
    extends StatelessWidget {
  final UserController controller;

  ProfileDetailScreen({
    super.key,
    UserController? controller,
  }) : controller = controller ??
      (Get.isRegistered<
          UserController>()
          ? Get.find<
          UserController>()
          : Get.put(
        UserController(),
      ));

  void _showMessage(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    Color backgroundColor = isError
        ? colorScheme.error
        : colorScheme.primary;

    Color foregroundColor = isError
        ? colorScheme.onError
        : colorScheme.onPrimary;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons
                    .error_outline_rounded
                    : Icons
                    .check_circle_outline_rounded,
                color: foregroundColor,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          backgroundColor,
          margin: EdgeInsets.all(14),
          duration: Duration(
            milliseconds: 1800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }

  void _handleMenu(
      BuildContext context,
      String value,
      ) {
    switch (value) {
      case 'share':
        _shareProfile(context);
        break;

      case 'block':
        _blockUser(context);
        break;
    }
  }

  void _openMessage(
      BuildContext context,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    _showMessage(
      context,
      'Open conversation with ${controller.name.value}',
    );
  }

  void _startCall(
      BuildContext context,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    _showMessage(
      context,
      'Calling ${controller.name.value}...',
    );
  }

  void _shareProfile(
      BuildContext context,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    _showMessage(
      context,
      'Share profile selected',
    );
  }

  void _openNotificationSettings(
      BuildContext context,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    _showMessage(
      context,
      'Notification settings selected',
    );
  }

  void _blockUser(
      BuildContext context,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    _showMessage(
      context,
      'Block user selected',
      isError: true,
    );
  }

  void _reportUser(
      BuildContext context,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    _showMessage(
      context,
      'Report user selected',
      isError: true,
    );
  }

  Future<void> _openMoreOptions(
      BuildContext context,
      ) async {
    await showProfileMoreOptionsSheet(
      context: context,
      userName: controller.name.value,
      onShareProfile: () {
        _shareProfile(context);
      },
      onNotifications: () {
        _openNotificationSettings(
          context,
        );
      },
      onBlockUser: () {
        _blockUser(context);
      },
      onReportUser: () {
        _reportUser(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    bool isDark =
        theme.brightness ==
            Brightness.dark;

    Color pageBackground = isDark
        ? theme.scaffoldBackgroundColor
        : Color(0xFFF6F7F9);

    return Scaffold(
      backgroundColor:
      pageBackground,
      appBar: ProfileAppBar(
        title: 'Profile Details',
        onBack: () {
          FocusManager.instance
              .primaryFocus
              ?.unfocus();

          Get.back();
        },
        onMenuSelected: (
            String value,
            ) {
          _handleMenu(
            context,
            value,
          );
        },
      ),
      body: Obx(
            () {
          return _buildProfileContent(
            context,
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context,
      ) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    bool isOnline = controller
        .status.value
        .trim()
        .toLowerCase() ==
        'online';

    return SafeArea(
      top: false,
      child: CustomScrollView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior
            .onDrag,
        physics:
        BouncingScrollPhysics(
          parent:
          AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              14,
              14,
              14,
              30,
            ),
            sliver: SliverList(
              delegate:
              SliverChildListDelegate(
                [
                  ProfileDetailHeader(
                    name:
                    controller.name.value,
                    status: controller
                        .status.value,
                    imageUrl: controller
                        .profileImageUrl
                        .value,
                    isOnline: isOnline,
                  ),
                  SizedBox(height: 14),
                  ProfileActions(
                    onMessage: () {
                      _openMessage(
                        context,
                      );
                    },
                    onCall: () {
                      _startCall(
                        context,
                      );
                    },
                    onMore: () {
                      _openMoreOptions(
                        context,
                      );
                    },
                  ),
                  SizedBox(height: 14),
                  ProfileInfoSection(
                    phoneNumber: controller
                        .phoneNumber.value,
                    username: controller
                        .username.value,
                    bio:
                    controller.bio.value,
                  ),
                  SizedBox(height: 14),
                  _buildNotificationCard(
                    context,
                    colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context,
      ColorScheme colorScheme,
      ) {
    ThemeData theme =
    Theme.of(context);

    bool isDark =
        theme.brightness ==
            Brightness.dark;

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
      borderRadius:
      BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          _openNotificationSettings(
            context,
          );
        },
        borderRadius:
        BorderRadius.circular(20),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(
              20,
            ),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme
                      .primary
                      .withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  Icons
                      .notifications_none_rounded,
                  color:
                  colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'Notifications',
                      style: theme
                          .textTheme.bodyLarge
                          ?.copyWith(
                        color: colorScheme
                            .onSurface,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage notifications from this user',
                      maxLines: 2,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons
                    .chevron_right_rounded,
                color: colorScheme
                    .onSurfaceVariant,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}