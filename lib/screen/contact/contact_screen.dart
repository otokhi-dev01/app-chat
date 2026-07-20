import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../services/contact_service.dart';
import '../../services/mock/mock_contact_service.dart';
import '../widgets/contact/contact_add_button.dart';
import '../widgets/contact/contact_add_group_button.dart';
import '../widgets/contact/contact_search_field.dart';
import 'add_group/add_group_screen.dart';
import 'contact_list.dart';

class ContactScreen extends StatelessWidget {
  ContactScreen({
    super.key,
  });

  ContactController get controller {
    if (!Get.isRegistered<ContactService>()) {
      Get.put<ContactService>(
        MockContactService(),
        permanent: true,
      );
    }

    if (Get.isRegistered<ContactController>()) {
      return Get.find<ContactController>();
    }

    return Get.put<ContactController>(
      ContactController(
        contactService:
        Get.find<ContactService>(),
      ),
      permanent: true,
    );
  }

  Future<void> _openAddGroupScreen() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    await Get.to(
          () => AddGroupScreen(),
      transition: Transition.cupertino,
      duration: Duration(
        milliseconds: 250,
      ),
      preventDuplicates: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    ContactController contactController =
        controller;

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              ContactSearchField(
                controller:
                contactController
                    .searchController,
                onChanged:
                contactController
                    .updateSearch,
                onClear:
                contactController
                    .clearSearch,
              ),

              ContactAddGroupButton(
                onTap: _openAddGroupScreen,
              ),

              Expanded(
                child: ContactList(
                  controller:
                  contactController,
                ),
              ),
            ],
          ),

          ContactAddButton(
            controller:
            contactController,
          ),
        ],
      ),
    );
  }
}