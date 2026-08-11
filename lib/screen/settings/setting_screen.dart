import 'package:appchat/screen/settings/section/display_langauge_settings_section.dart';
import 'package:appchat/screen/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import 'section/about_settings_section.dart';
import 'section/contact_settings_section.dart';
import 'section/general_settings_section.dart';

class SettingScreen extends StatelessWidget {
  final bool showTopPadding;

  const SettingScreen({
    super.key,
    this.showTopPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = Get.find<SettingsController>();
    NotificationController notificationController = Get.find<NotificationController>();
    ContactController contactController = Get.find<ContactController>();

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        String appVersion = snapshot.data?.version ?? '';
        String buildNumber = snapshot.data?.buildNumber ?? '';

        return ListView(
          physics: BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            16,
            showTopPadding ? 18 : 12,
            16,
            120,
          ),
          children: [
            // AccountSettingsSection(
            //   controller: profileController,
            // ),
            //

            GeneralSettingsSection(
              settingsController: settingsController,
              notificationController: notificationController,
            ),

            SizedBox(height: 24),

            ContactSettingsSection(
              contactController: contactController,
            ),

            SizedBox(height: 24),

            // DisplaySettingsSection(
            //   controller: settingsController,
            // ),
            //
            // SizedBox(height: 24),
            //
            // LanguageSettingsSection(
            //   controller: settingsController,
            // ),

            DisplayLanguageSettingsSection(controller: settingsController),


            SizedBox(height: 24),

            AboutSettingsSection(
              appVersion: appVersion,
              buildNumber: buildNumber,
            ),

            SizedBox(height: 24),

            LogoutButton(
              controller: settingsController,
            ),
          ],
        );
      },
    );
  }
}