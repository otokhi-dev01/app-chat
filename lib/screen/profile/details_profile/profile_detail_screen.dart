import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/user/user_controller.dart';
import '../../../route/app_route.dart';
import '../../contact/add_contact/add_contact_screen.dart';
import '../../widgets/app_feedback.dart';
import 'profile_content_filter.dart';
import 'profile_detail_app_bar.dart';
import 'profile_detail_content.dart';
import 'profile_more_option_sheet.dart';

class ProfileDetailScreen extends StatefulWidget {
  final UserController controller;

  ProfileDetailScreen({
    super.key,
    UserController? controller,
  }) : controller = controller ??
      (Get.isRegistered<UserController>()
          ? Get.find<UserController>()
          : Get.put(
        UserController(),
      ));

  @override
  State<ProfileDetailScreen> createState() {
    return _ProfileDetailScreenState();
  }
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  ProfileContentFilterType selectedFilter = ProfileContentFilterType.posts;

  UserController get controller {
    return widget.controller;
  }

  Future<void> _openAddContact(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    dynamic result = await Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute<dynamic>(
        fullscreenDialog: false,
        builder: (
            BuildContext routeContext,
            ) {
          return AddContactScreen(
            name: controller.name.value,
            username: controller.username.value,
            phoneNumber: controller.phoneNumber.value,
            imageUrl: controller.profileImageUrl.value,
          );
        },
      ),
    );

    if (!mounted || result is! Map) {
      return;
    }

    Map<dynamic, dynamic> resultData = result;

    if (resultData['saved'] != true) {
      return;
    }

    String contactName =
        resultData['name']?.toString() ?? controller.name.value;

    AppFeedback.showMessage(
      title: 'contact_added'.tr,
      message: 'contact_added_message'.trParams(
        {
          'name': contactName,
        },
      ),
      icon: CupertinoIcons.person_badge_plus,
    );
  }

  void _openMessage() {
    FocusManager.instance.primaryFocus?.unfocus();

    Get.back();
  }

  void _startCall() {
    FocusManager.instance.primaryFocus?.unfocus();

    Get.toNamed(
      AppRoutes.call,
      arguments: {
        'name': controller.name.value,
        'isVideo': false,
      },
    );
  }

  Future<void> _shareProfile(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String name = controller.name.value.trim();

    if (name.isEmpty) {
      name = 'appchat_user'.tr;
    }

    String username = controller.username.value.trim();

    String normalizedUsername =
    username.startsWith('@') ? username.substring(1) : username;

    String displayUsername =
    normalizedUsername.isEmpty ? '' : '@$normalizedUsername';

    StringBuffer shareMessage = StringBuffer();

    shareMessage.writeln(
      'share_profile_intro'.trParams(
        {
          'name': name,
        },
      ),
    );

    if (displayUsername.isNotEmpty) {
      shareMessage.writeln();

      shareMessage.writeln(
        'share_profile_username'.trParams(
          {
            'username': displayUsername,
          },
        ),
      );
    }

    shareMessage.writeln();

    shareMessage.write(
      'share_profile_instruction'.tr,
    );

    try {
      ShareResult result = await SharePlus.instance.share(
        ShareParams(
          title: 'share_profile'.tr,
          subject: 'share_profile_subject'.trParams(
            {
              'name': name,
            },
          ),
          text: shareMessage.toString().trim(),
          sharePositionOrigin: _getSharePositionOrigin(
            context,
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      switch (result.status) {
        case ShareResultStatus.success:
          AppFeedback.showMessage(
            title: 'profile_shared'.tr,
            message: 'profile_shared_message'.tr,
            icon: CupertinoIcons.share,
          );
          break;

        case ShareResultStatus.dismissed:
          break;

        case ShareResultStatus.unavailable:
          AppFeedback.showMessage(
            title: 'sharing_unavailable'.tr,
            message: 'sharing_unavailable_message'.tr,
            icon: CupertinoIcons.exclamationmark_circle,
          );
          break;
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Share profile error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'unable_to_share_profile'.tr,
        message: 'unable_to_share_profile_message'.tr,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    }
  }

  Rect _getSharePositionOrigin(
      BuildContext context,
      ) {
    RenderObject? renderObject = context.findRenderObject();

    if (renderObject is RenderBox && renderObject.hasSize) {
      Offset globalPosition = renderObject.localToGlobal(
        Offset.zero,
      );

      Size size = renderObject.size;

      if (size.width > 0 && size.height > 0) {
        return Rect.fromLTWH(
          globalPosition.dx,
          globalPosition.dy,
          size.width,
          size.height,
        );
      }
    }

    Size screenSize = MediaQuery.sizeOf(context);

    return Rect.fromLTWH(
      screenSize.width / 2,
      screenSize.height / 2,
      1,
      1,
    );
  }

  void _openNotificationSettings() {
    FocusManager.instance.primaryFocus?.unfocus();

    AppFeedback.showMessage(
      title: 'notification_settings'.tr,
      message: 'notification_settings_message'.tr,
      icon: CupertinoIcons.bell,
    );
  }

  void _blockUser() {
    FocusManager.instance.primaryFocus?.unfocus();

    AppFeedback.showMessage(
      title: 'user_blocked'.tr,
      message: 'user_blocked_message'.trParams(
        {
          'name': controller.name.value,
        },
      ),
      icon: CupertinoIcons.slash_circle,
    );
  }

  Future<void> _openMoreOptions(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showProfileMoreOptionsSheet(
      context: context,
      userName: controller.name.value,
      onShareProfile: () {
        _shareProfile(
          context,
        );
      },
      onNotifications: _openNotificationSettings,
      onBlockUser: _blockUser,
    );
  }

  void _changeFilter(
      ProfileContentFilterType filter,
      ) {
    if (selectedFilter == filter) {
      return;
    }

    setState(() {
      selectedFilter = filter;
    });
  }

  void _openQrCode() {
    FocusManager.instance.primaryFocus?.unfocus();

    Get.toNamed(
      AppRoutes.profileQrCode,
      arguments: <String, dynamic>{
        'name': controller.name.value,
        'username': controller.username.value,
      },
    );
  }

  void _closeScreen() {
    FocusManager.instance.primaryFocus?.unfocus();

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark = theme.brightness == Brightness.dark;

    Color pageBackground =
    isDark ? theme.scaffoldBackgroundColor : Color(0xFFF6F7F9);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: false,
      backgroundColor: pageBackground,
      appBar: ProfileAppBar(
        title: 'profile_details'.tr,
        onBack: _closeScreen,
        onQrCodeTap: _openQrCode,
      ),
      body: ProfileDetailContent(
        controller: controller,
        selectedFilter: selectedFilter,
        onFilterChanged: _changeFilter,
        onMessage: _openMessage,
        onCall: _startCall,
        onMore: () {
          _openMoreOptions(
            context,
          );
        },
        onAddContact: () {
          _openAddContact(
            context,
          );
        },
      ),
    );
  }
}