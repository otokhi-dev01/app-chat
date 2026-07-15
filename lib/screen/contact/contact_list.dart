import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact_controller.dart';
import '../../../models/contact_model.dart';
import '../widgets/contact/contact_empty_state.dart';
import '../widgets/contact/contact_section_header.dart';
import '../widgets/contact/contact_title.dart';

class ContactList extends StatelessWidget {
  final ContactController controller;

  ContactList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        Map<String, List<ContactModel>> grouped =
            controller.groupedContacts;

        List<String> letters =
        grouped.keys.toList();

        letters.sort();

        if (letters.isEmpty) {
          return ContactEmptyState(
            hasSearchQuery: controller
                .searchQuery.value
                .trim()
                .isNotEmpty,
          );
        }

        return ListView.builder(
          controller:
          controller.scrollController,
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          physics: BouncingScrollPhysics(
            parent:
            AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.only(
            top: 4,
            bottom: 120,
          ),
          itemCount: letters.length,
          itemBuilder: (
              BuildContext context,
              int index,
              ) {
            String letter = letters[index];

            List<ContactModel> contacts =
                grouped[letter] ??
                    <ContactModel>[];

            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                ContactSectionHeader(
                  letter: letter,
                ),
                ...contacts.map(
                      (ContactModel contact) {
                    return ContactTile(
                      key: ValueKey(
                        contact.name,
                      ),
                      contact: contact,
                      onTap: () {
                        controller.openContact(
                          contact,
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}