
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../controllers/contact/contact_controller.dart';
import '../../route/app_route.dart';
import 'home_app_bar_button.dart';
import '../contact/add_contact/add_contact_sheet.dart';
import 'new_message_sheet.dart';

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
              tooltip: 'new_message'.tr,
              icon: CupertinoIcons.square_pencil,
              backgroundColor: backgroundColor,
              foregroundColor: iconColor,
              onPressed: () {
                NewMessageSheet.show(
                  context: context,
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
            showAddContactSheet(
              context: context,
              onAdd: (data) async {
                // Use ContactController if registered, else just log
                if (Get.isRegistered<ContactController>()) {
                  final ctrl = Get.find<ContactController>();
                  final parts = data.phoneNumber.split(' ');
                  await ctrl.addPhoneContact(
                    firstName: data.firstName,
                    lastName: data.lastName.isNotEmpty ? data.lastName : null,
                    phoneNumber: data.phoneNumber,
                  );
                } else {
                  debugPrint('Adding contact: ${data.firstName} ${data.lastName}, ${data.phoneNumber}');
                }
              },
              onAddViaQrCode: () {},
            );
          },
        );

      case 2:
        return const SizedBox.shrink();

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