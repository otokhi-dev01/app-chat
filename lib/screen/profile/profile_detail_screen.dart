import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../widgets/profile_detail/profile_detail_action.dart';
import '../widgets/profile_detail/profile_detail_app_bar.dart';
import '../widgets/profile_detail/profile_detail_header.dart';
import '../widgets/profile_detail/profile_detail_info_section.dart';

class ProfileDetailScreen extends StatelessWidget {
  final int userId;

  late final String controllerTag;
  late final UserController controller;

  ProfileDetailScreen({
    super.key,
    required this.userId,
  }) {
    controllerTag = 'profile-user-$userId';

    controller = Get.isRegistered<UserController>(
      tag: controllerTag,
    )
        ? Get.find<UserController>(
      tag: controllerTag,
    )
        : Get.put(
      UserController(
        userId: userId,
      ),
      tag: controllerTag,
    );
  }

  void _showMessage(
      BuildContext context,
      String message,
      ) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.primary,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
        _showMessage(
          context,
          'Share profile selected',
        );
        break;

      case 'block':
        _showMessage(
          context,
          'Block user selected',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pageBackground = isDark
        ? theme.scaffoldBackgroundColor
        : Color(0xFFF6F7F9);

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: ProfileAppBar(
        title: 'Profile Details',
        onBack: () {
          FocusManager.instance.primaryFocus
              ?.unfocus();

          Get.back();
        },
        onMenuSelected: (String value) {
          _handleMenu(context, value);
        },
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState(context);
          }

          return _buildProfileContent(context);
        },
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isOnline =
        controller.status.value
            .trim()
            .toLowerCase() ==
            'online';

    return SafeArea(
      top: false,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              14,
              14,
              14,
              30,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProfileDetailHeader(
                    name: controller.name.value,
                    status: controller.status.value,
                    imageUrl:
                    controller.profileImageUrl.value,
                    isOnline: isOnline,
                  ),

                  SizedBox(height: 14),

                  ProfileActions(
                    isFollowing:
                    controller.isFollowing.value,
                    onMessage: () {
                      _showMessage(
                        context,
                        'Open conversation with '
                            '${controller.name.value}',
                      );
                    },
                    onCall: () {
                      _showMessage(
                        context,
                        'Calling '
                            '${controller.name.value}...',
                      );
                    },
                    onFollow: controller.toggleFollow,
                  ),

                  SizedBox(height: 14),

                  ProfileInfoSection(
                    phoneNumber:
                    controller.phoneNumber.value,
                    username:
                    controller.username.value,
                    bio: controller.bio.value,
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

  Widget _buildErrorState(
      BuildContext context,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_off_outlined,
                color: colorScheme.error,
                size: 34,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Could not load profile',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 7),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 18),
            FilledButton(
              onPressed: controller.loadUserById,
              child: Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context,
      ColorScheme colorScheme,
      ) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          _showMessage(
            context,
            'Notification settings selected',
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                  color: colorScheme.primary.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage notifications from this user',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color:
                colorScheme.onSurfaceVariant,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}