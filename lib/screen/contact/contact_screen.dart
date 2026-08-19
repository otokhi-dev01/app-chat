import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../route/app_route.dart';
import '../../services/contact_service/contact_api_service.dart';
import 'add_contact/contact_add_button.dart';
import 'add_group/contact_add_group_button.dart';
import 'contact_search_field.dart';
import 'contact_list.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({
    super.key,
  });

  ContactController get controller {
    if (Get.isRegistered<ContactController>()) {
      return Get.find<ContactController>();
    }

    return Get.put<ContactController>(
      ContactController(
        contactApiService: Get.find<ContactApiService>(),
      ),
      permanent: true,
    );
  }

  Future<void> _openAddGroupScreen() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await Get.toNamed(AppRoutes.addGroup);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    ContactController contactController = controller;

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              ContactSearchField(
                controller: contactController.searchController,
                onChanged: contactController.updateSearch,
                onClear: contactController.clearSearch,
              ),

              ContactAddGroupButton(
                onTap: _openAddGroupScreen,
              ),

              Expanded(
                child: ContactList(
                  controller: contactController,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}