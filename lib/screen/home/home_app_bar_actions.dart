import 'package:appchat/screen/profile/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../controllers/contact/contact_controller.dart';
import '../../controllers/settings/settings_search_controller.dart';
import '../../route/app_route.dart';
import '../settings/settings_search_screen.dart';
import 'home_app_bar_button.dart';
import 'home_chat_menu.dart';

class HomeAppBarActions extends StatelessWidget {
  final int selectedIndex;
  final ChatController controller;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<String> onChatMenuSelected;

  const HomeAppBarActions({
    super.key,
    required this.selectedIndex,
    required this.controller,
    required this.backgroundColor,
    required this.iconColor,
    required this.onChatMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeAppBarActionButton(
              tooltip: 'search_chats'.tr,
              icon: Icons.search_rounded,
              backgroundColor: backgroundColor,
              foregroundColor: iconColor,
              onPressed: controller.openSearchScreen,
            ),
            SizedBox(width: 5),
            HomeChatMenu(
              onSelected: onChatMenuSelected,
            ),
          ],
        );

      case 1:
        return const SizedBox.shrink();

      case 2:
        return HomeAppBarActionButton(
          tooltip: 'search_settings'.tr,
          icon: Icons.search_rounded,
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();

            dynamic result = await Get.toNamed(
              AppRoutes.settingsSearch,
            );

            String? selectedSetting = result is String ? result : null;

            if (selectedSetting == null) {
              return;
            }

            debugPrint(
              'Selected setting: $selectedSetting',
            );
          },
        );

      case 3:
        return HomeAppBarActionButton(
          tooltip: 'edit_profile'.tr,
          icon: Icons.edit_rounded,
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          onPressed: () {
            Get.to(
                  () => ProfileEditScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 280),
              opaque: false, // <-- CRITICAL: Allows you to see the previous screen in the background
            );
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}