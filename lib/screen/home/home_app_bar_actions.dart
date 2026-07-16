import 'package:appchat/screen/profile/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import 'home_app_bar_button.dart';
import 'home_chat_menu.dart';

class HomeAppBarActions extends StatelessWidget {
  final int selectedIndex;
  final ChatController controller;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<String> onChatMenuSelected;

  HomeAppBarActions({
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeAppBarActionButton(
              tooltip: 'search_contacts'.tr,
              icon: Icons.search_rounded,
              backgroundColor: backgroundColor,
              foregroundColor: iconColor,
              onPressed: () {},
            ),
            SizedBox(width: 5),
            HomeAppBarActionButton(
              tooltip: 'add_contact'.tr,
              icon: Icons.person_add_alt_1_rounded,
              backgroundColor: backgroundColor,
              foregroundColor: iconColor,
              onPressed: () {},
            ),
          ],
        );

      case 2:
        return HomeAppBarActionButton(
          tooltip: 'search_settings'.tr,
          icon: Icons.search_rounded,
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          onPressed: () {},
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
              duration: Duration(milliseconds: 280),
            );
          },
        );

      default:
        return SizedBox.shrink();
    }
  }
}