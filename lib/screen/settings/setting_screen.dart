import 'package:appchat/screen/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings/settings_controller.dart';
import '../widgets/settings/account_screen.dart';
import '../widgets/settings/display_settings_section.dart';
import '../widgets/settings/general_settings_section.dart';
import '../widgets/settings/language_settings_section.dart';

class SettingScreen extends StatelessWidget {
  final bool showTopPadding;

  SettingScreen({
    super.key,
    this.showTopPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    SettingsController controller =
    Get.find<SettingsController>();

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
          controller: controller,
        ),

        SizedBox(height: 24),

        GeneralSettingsSection(
          controller: controller,
        ),

        SizedBox(height: 24),

        DisplaySettingsSection(
          controller: controller,
        ),

        SizedBox(height: 24),

        LanguageSettingsSection(
          controller: controller,
        ),

        SizedBox(height: 24),

        LogoutButton(
          controller: controller,
        ),
      ],
    );
  }
}