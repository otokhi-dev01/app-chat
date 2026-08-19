
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../route/app_route.dart';
import 'home_app_bar_button.dart';
import 'add_contact_sheet.dart';

class HomeAppBarActions extends StatelessWidget {
  final int selectedIndex;
  final ChatController controller;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<String> onChatMenuSelected;
  final VoidCallback? onNavigateToContacts;

  const HomeAppBarActions({
    super.key,
    required this.selectedIndex,
    required this.controller,
    required this.backgroundColor,
    required this.iconColor,
    required this.onChatMenuSelected,
    this.onNavigateToContacts,
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
              icon: CupertinoIcons.search,
              backgroundColor: backgroundColor,
              foregroundColor: iconColor,
              onPressed: controller.openSearchScreen,
            ),
            const SizedBox(width: 8),
            HomeAppBarActionButton(
              tooltip: 'add_contact'.tr,
              icon: CupertinoIcons.add,
              backgroundColor: backgroundColor,
              foregroundColor: iconColor,
              onPressed: () {
                AddContactSheet.show(
                  context: context,
                  onSave: (firstName, lastName, phone, countryCode) async {
                    debugPrint('Adding contact: $firstName $lastName, $countryCode$phone');
                  },
                );
              },
            ),
          ],
        );

      case 1:
        return HomeAppBarActionButton(
          tooltip: 'add_contact'.tr,
          icon: CupertinoIcons.person_add,
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          onPressed: () {
            AddContactSheet.show(
              context: context,
              onSave: (firstName, lastName, phone, countryCode) async {
                // The implementation for adding by phone number goes here
                debugPrint('Adding contact: $firstName $lastName, $countryCode$phone');
              },
            );
          },
        );

      case 2:
      // UPDATED: Settings Search button (case 2: Settings Tab) navigating to AppRoutes.settingsSearch
        return HomeAppBarActionButton(
          tooltip: 'search_settings'.tr,
          icon: CupertinoIcons.search,
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          onPressed: () async {
            // UPDATED: Dismisses keyboard cleanly before initiating page transition
            FocusManager.instance.primaryFocus?.unfocus();

            // UPDATED: Opens SettingsSearchScreen via GetX route and awaits selected setting result
            dynamic result = await Get.toNamed(
              AppRoutes.settingsSearch,
            );

            String? selectedSetting = result is String ? result : null;

            if (selectedSetting == null) return;

            debugPrint('Selected setting: $selectedSetting');
          },
        );

      case 3:
        return HomeAppBarActionButton(
          tooltip: 'edit_profile'.tr,
          icon: CupertinoIcons.pencil,
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          onPressed: () {
            // FIXED: Uses Get.toNamed with AppRoutes.editProfile to navigate to ProfileEditScreen
            Get.toNamed(AppRoutes.editProfile);
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}