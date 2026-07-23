import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/add_group_controller.dart';
import '../../../models/contact_model.dart';
import '../../widgets/add_group/add_group_content.dart';
import 'add_group_app_bar.dart';

class AddGroupScreen extends StatelessWidget {
  final AddGroupController controller;

  AddGroupScreen({
    super.key,
    AddGroupController? controller,
  }) : controller = controller ??
      (Get.isRegistered<AddGroupController>()
          ? Get.find<AddGroupController>()
          : Get.put(
        AddGroupController(),
      ));

  Future<void> _createGroup(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool created =
    await controller.createGroup();

    if (!context.mounted) {
      return;
    }

    if (!created) {
      _showMessage(
        message: controller.errorMessage.value,
        icon: Icons.error_outline_rounded,
      );

      return;
    }

    String groupName =
        controller.groupName.value;

    String imagePath =
        controller.groupImagePath.value;

    List<String> memberIds =
    controller.selectedMembers
        .map(
          (ContactModel contact) {
        return contact.id;
      },
    )
        .toList(
      growable: false,
    );

    Get.back(
      result: <String, dynamic>{
        'name': groupName,
        'imagePath': imagePath,
        'memberIds': memberIds,
      },
    );
  }

  void _showMessage({
    required String message,
    required IconData icon,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      'unable_to_create_group'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 16,
      icon: Icon(
        icon,
      ),
      duration: Duration(
        seconds: 3,
      ),
      isDismissible: true,
      dismissDirection:
      DismissDirection.horizontal,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize:
        Size.fromHeight(64),
        child: Obx(
              () {
            return AddGroupAppBar(
              canCreate:
              controller.canCreateGroup,
              isCreating:
              controller.isCreating.value,
              onCreate: () {
                _createGroup(
                  context,
                );
              },
            );
          },
        ),
      ),
      body: AddGroupContent(
        controller: controller,
      ),
    );
  }
}