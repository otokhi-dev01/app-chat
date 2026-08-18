import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/add_group_controller.dart';
import 'add_group_content.dart';
import '../../widgets/app_feedback.dart';
import 'add_group_app_bar.dart';

class AddGroupScreen extends GetView<AddGroupController> {
  const AddGroupScreen({super.key});

  Future<void> _createGroup(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool created = await controller.createGroup();

    if (!context.mounted) return;

    if (!created) {
      AppFeedback.showMessage(
        title: 'unable_to_create_group'.tr,
        message: controller.errorMessage.value,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Obx(
          () => AddGroupAppBar(
            canCreate: controller.canCreateGroup,
            isCreating: controller.isCreating.value,
            onCreate: () => _createGroup(context),
          ),
        ),
      ),
      body: AddGroupContent(
        controller: controller,
      ),
    );
  }
}