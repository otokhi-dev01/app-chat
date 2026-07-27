import 'package:appchat/screen/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../widgets/settings/account_screen.dart';
import '../widgets/settings/display_settings_section.dart';
import '../widgets/settings/general_settings_section.dart';
import '../widgets/settings/language_settings_section.dart';

class SettingScreen extends StatelessWidget {
  final bool showTopPadding;

  const SettingScreen({
    super.key,
    this.showTopPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController =
    Get.find<SettingsController>();

    ProfileController profileController =
    Get.find<ProfileController>();

    NotificationController notificationController =
    Get.find<NotificationController>();

    ContactController contactController =
    Get.find<ContactController>();

    return ListView(
      physics: BouncingScrollPhysics(),
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        16,
        showTopPadding ? 18 : 12,
        16,
        120,
      ),
      children: [
        AccountSettingsSection(
          controller: profileController,
        ),

        SizedBox(height: 24),

        GeneralSettingsSection(
          settingsController: settingsController,
          notificationController:
          notificationController,
          contactController: contactController,
        ),

        SizedBox(height: 24),

        DisplaySettingsSection(
          controller: settingsController,
        ),

        SizedBox(height: 24),

        LanguageSettingsSection(
          controller: settingsController,
        ),

        SizedBox(height: 24),

        LogoutButton(
          controller: settingsController,
        ),
      ],
    );
  }
}