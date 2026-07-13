import 'package:appchat/screen/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../widgets/settings/account_screen.dart';
import '../widgets/settings/display_settings_section.dart';
import '../widgets/settings/general_settings_section.dart';
import '../widgets/settings/language_settings_section.dart';
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller =
    Get.find<SettingsController>();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        120,
      ),
      children: [
        AccountSettingsSection
          (controller: controller
        ),

        const SizedBox(height: 24),

        GeneralSettingsSection(
          controller: controller,
        ),

        const SizedBox(height: 24),

        DisplaySettingsSection(
          controller: controller,
        ),

        const SizedBox(height: 24),

        LanguageSettingsSection(
          controller: controller,
        ),

        const SizedBox(height: 24),

        LogoutButton
          (controller: controller
        ),

      ],
    );
  }
}