import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../models/contact_model.dart';

class ContactController extends GetxController {
  final TextEditingController searchController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  final RxList<ContactModel> contacts =
      <ContactModel>[].obs;

  final RxString searchQuery = ''.obs;
  final RxBool showAddButton = true.obs;

  @override
  void onInit() {
    super.onInit();

    contacts.assignAll([
      ContactModel(
        name: 'Alex Morgan',
        status: ContactStatus.online,
      ),
      ContactModel(
        name: 'Amanda Lee',
        status: ContactStatus.offline,
      ),
      ContactModel(
        name: 'Brian Cooper',
        status: ContactStatus.recently,
      ),
      ContactModel(
        name: 'Chloe Bennett',
        status: ContactStatus.online,
      ),
      ContactModel(
        name: 'Daniel Kim',
        status: ContactStatus.offline,
      ),
      ContactModel(
        name: 'Emma Watson',
        status: ContactStatus.recently,
      ),
      ContactModel(
        name: 'Ethan Parker',
        status: ContactStatus.online,
      ),
      ContactModel(
        name: 'Fiona Davis',
        status: ContactStatus.offline,
      ),
      ContactModel(
        name: 'George Miller',
        status: ContactStatus.online,
      ),
      ContactModel(
        name: 'Hannah Scott',
        status: ContactStatus.recently,
      ),
    ]);

    scrollController.addListener(
      _handleScroll,
    );
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchQuery.value = '';

    if (searchController.text.isNotEmpty) {
      searchController.clear();
    }
  }

  List<ContactModel> get filteredContacts {
    String query =
    searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return contacts.toList();
    }

    return contacts.where(
          (ContactModel contact) {
        return contact.name
            .toLowerCase()
            .contains(query);
      },
    ).toList();
  }

  Map<String, List<ContactModel>>
  get groupedContacts {
    Map<String, List<ContactModel>> grouped =
    <String, List<ContactModel>>{};

    for (ContactModel contact
    in filteredContacts) {
      String name = contact.name.trim();

      if (name.isEmpty) {
        continue;
      }

      String firstLetter =
      name[0].toUpperCase();

      grouped.putIfAbsent(
        firstLetter,
            () {
          return <ContactModel>[];
        },
      );

      grouped[firstLetter]!.add(contact);
    }

    for (List<ContactModel> contactList
    in grouped.values) {
      contactList.sort(
            (
            ContactModel first,
            ContactModel second,
            ) {
          return first.name.compareTo(
            second.name,
          );
        },
      );
    }

    return grouped;
  }

  List<String> get contactLetters {
    List<String> letters =
    groupedContacts.keys.toList();

    letters.sort();

    return letters;
  }

  void _handleScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    ScrollDirection direction =
        scrollController
            .position.userScrollDirection;

    if (direction ==
        ScrollDirection.reverse) {
      if (showAddButton.value) {
        showAddButton.value = false;
      }

      return;
    }

    if (direction ==
        ScrollDirection.forward) {
      if (!showAddButton.value) {
        showAddButton.value = true;
      }
    }
  }

  void openAddContact() {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    // TODO: Navigate to AddContactScreen.
  }

  void openContact(ContactModel contact) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    // TODO: Navigate to ContactDetailScreen.
  }

  void addContact(ContactModel contact) {
    contacts.add(contact);
  }

  void removeContact(ContactModel contact) {
    contacts.remove(contact);
  }

  @override
  void onClose() {
    scrollController.removeListener(
      _handleScroll,
    );

    scrollController.dispose();
    searchController.dispose();

    super.onClose();
  }
}