import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../services/contact_service.dart';
import '../../services/mock_contact_service.dart';
import '../widgets/contact/contact_add_button.dart';

import '../widgets/contact/contact_search_field.dart';
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              ContactSearchField(
                controller:
                controller.searchController,
                onChanged:
                controller.updateSearch,
                onClear:
                controller.clearSearch,
              ),
              Expanded(
                child: ContactList(
                  controller: controller,
                ),
              ),
            ],
          ),
          ContactAddButton(
            controller: controller,
          ),
        ],
      ),
    );
  }
}