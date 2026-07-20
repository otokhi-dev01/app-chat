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
      (Get.isRegistered<
          AddGroupController>()
          ? Get.find<
          AddGroupController>()
          : Get.put(
        AddGroupController(),
      ));

  Future<void> _createGroup(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    bool created =
    await controller.createGroup();

    if (!context.mounted) {
      return;
    }

    if (!created) {
      _showMessage(
        context: context,
        message:
        controller.errorMessage.value,
        isError: true,
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
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    Color backgroundColor = isError
        ? colorScheme.error
        : colorScheme.primary;

    Color foregroundColor = isError
        ? colorScheme.onError
        : colorScheme.onPrimary;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          backgroundColor,
          margin: EdgeInsets.all(14),
          duration: Duration(
            milliseconds: 1800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons
                    .error_outline_rounded
                    : Icons
                    .check_circle_outline_rounded,
                color: foregroundColor,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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