import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../models/contact_model.dart';
import '../../controllers/contact/contact_controller.dart';
import 'contact_empty_state.dart';
import 'contact_section_header.dart';
import 'contact_title.dart';
import 'edit_contact/edit_contact_sheet.dart';

class ContactList extends StatelessWidget {
  final ContactController controller;

  const ContactList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        Map<String, List<ContactModel>> grouped = controller.groupedContacts;

        List<String> letters = grouped.keys.toList();

        letters.sort((String first, String second) {
          return first.toLowerCase().compareTo(second.toLowerCase());
        });

        if (letters.isEmpty) {
          return ContactEmptyState(
            hasSearchQuery: controller.searchQuery.value.trim().isNotEmpty,
          );
        }

        return ListView.builder(
          controller: controller.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 120,
          ),
          itemCount: letters.length,
          itemBuilder: (BuildContext context, int index) {
            String letter = letters[index];

            List<ContactModel> contacts = grouped[letter] ?? <ContactModel>[];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContactSectionHeader(letter: letter),
                ...contacts.map(
                  (ContactModel contact) {
                    return GestureDetector(
                      key: ValueKey<String>(contact.id),
                      behavior: HitTestBehavior.opaque,
                      onLongPress: () {
                        _showContactActionSheet(context, contact);
                      },
                      child: ContactTile(
                        contact: contact,
                        onTap: () {
                          controller.openContact(contact);
                        },
                      ),
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

  /// Shows the action sheet with: Message · Edit · Delete
  Future<void> _showContactActionSheet(
    BuildContext context,
    ContactModel contact,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return CupertinoActionSheet(
          title: Text(
            contact.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          message: Text(
            contact.phoneNumber.trim().isNotEmpty
                ? contact.phoneNumber
                : 'contact_options'.tr,
            style: const TextStyle(fontSize: 12),
          ),
          actions: [
            // Send Message
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                controller.openContact(contact);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.chat_bubble, size: 20),
                  const SizedBox(width: 8),
                  Text('send_message'.tr),
                ],
              ),
            ),

            // Edit Contact — only available for raw phone contacts
            if (_isPhoneContact(contact))
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _openEditSheet(context, contact);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.pencil, size: 20),
                    const SizedBox(width: 8),
                    Text('edit_contact'.tr),
                  ],
                ),
              ),

            // Delete Contact
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(sheetContext).pop();
                _confirmDeleteContact(context, contact);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: CupertinoColors.destructiveRed,
                  ),
                  const SizedBox(width: 8),
                  Text('delete_contact'.tr),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: Text('cancel'.tr),
          ),
        );
      },
    );
  }

  /// Opens the Edit Contact bottom sheet
  Future<void> _openEditSheet(
    BuildContext context,
    ContactModel contact,
  ) async {
    await showEditContactSheet(
      context: context,
      contact: contact,
      onSave: (firstName, lastName, phoneNumber) async {
        await controller.editPhoneContact(
          contact: contact,
          firstName: firstName,
          lastName: lastName.isNotEmpty ? lastName : null,
          phoneNumber: phoneNumber,
        );
      },
    );
  }

  /// Returns true if this contact belongs to the phone-contacts API
  bool _isPhoneContact(ContactModel contact) {
    return contact.id.startsWith('phone_') || !contact.isRegisteredUser;
  }

  /// Confirmation dialog before deleting
  Future<void> _confirmDeleteContact(
    BuildContext context,
    ContactModel contact,
  ) async {
    bool? shouldDelete = await Get.dialog<bool>(
      CupertinoAlertDialog(
        title: Text('delete_contact'.tr),
        content: Text(
          'are_you_sure_delete_contact'.trParams({'name': contact.name}),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Get.back(result: true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await controller.removeContact(contact);
    }
  }
}