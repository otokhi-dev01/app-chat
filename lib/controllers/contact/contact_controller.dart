import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../../models/contact_model.dart';
import '../../screen/chat_detail/chat_detail_screen.dart';
import '../../services/contact_service.dart';

class ContactController extends GetxController {
  final ContactService contactService;

  ContactController({
    required this.contactService,
  });

  final TextEditingController searchController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  final RxList<ContactModel> contacts =
      <ContactModel>[].obs;

  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;

  final RxBool showAddButton = true.obs;
  final RxBool isNameAscending = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAddingContact = false.obs;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(
      _handleScroll,
    );

    loadContacts();
  }

  Future<void> loadContacts() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      List<ContactModel> result =
      await contactService.getContacts();

      contacts.assignAll(result);

      _sortContacts();
    } catch (error) {
      errorMessage.value =
      'Failed to load contacts: $error';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshContacts() async {
    await loadContacts();
  }

  Future<void> retry() async {
    await loadContacts();
  }

  void updateSearch(String value) {
    searchQuery.value = value.trim();
  }

  void clearSearch() {
    searchQuery.value = '';

    if (searchController.text.isNotEmpty) {
      searchController.clear();
    }
  }

  bool contactPhoneExists(
      String phoneNumber,
      ) {
    String normalizedPhone =
    _normalizePhoneNumber(phoneNumber);

    return contacts.any(
          (ContactModel contact) {
        return _normalizePhoneNumber(
          contact.phoneNumber,
        ) ==
            normalizedPhone;
      },
    );
  }

  Future<void> addContact({
    required String name,
    required String phoneNumber,
  }) async {
    String cleanName = name.trim();
    String cleanPhoneNumber =
    phoneNumber.trim();

    if (cleanName.isEmpty ||
        cleanPhoneNumber.isEmpty) {
      Get.snackbar(
        'Invalid contact',
        'Name and phone number are required.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (contactPhoneExists(
      cleanPhoneNumber,
    )) {
      Get.snackbar(
        'Contact already exists',
        'This phone number is already in your contacts.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (isAddingContact.value) {
      return;
    }

    try {
      isAddingContact.value = true;
      errorMessage.value = '';

      ContactModel contact =
      await contactService.addManualContact(
        name: cleanName,
        phoneNumber: cleanPhoneNumber,
      );

      contacts.add(contact);

      _sortContacts();

      debugPrint(
        'Contact added: ${contact.id}',
      );
    } catch (error) {
      errorMessage.value =
      'Failed to add contact: $error';

      Get.snackbar(
        'Unable to add contact',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAddingContact.value = false;
    }
  }

  Future<void> addContactByUserId(
      String userId,
      ) async {
    String cleanUserId = userId.trim();

    if (cleanUserId.isEmpty) {
      return;
    }

    bool exists = contacts.any(
          (ContactModel contact) {
        return contact.id == cleanUserId;
      },
    );

    if (exists) {
      Get.snackbar(
        'Contact already exists',
        'This user is already in your contacts.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isAddingContact.value = true;
      errorMessage.value = '';

      ContactModel? contact =
      await contactService
          .addContactByUserId(
        cleanUserId,
      );

      if (contact == null) {
        Get.snackbar(
          'User not found',
          'Unable to find this user.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      contacts.add(contact);

      _sortContacts();
    } catch (error) {
      errorMessage.value =
      'Failed to add contact: $error';
    } finally {
      isAddingContact.value = false;
    }
  }

  Future<void> addContactModel(
      ContactModel contact,
      ) async {
    bool contactExists = contacts.any(
          (ContactModel item) {
        return item.id == contact.id ||
            _normalizePhoneNumber(
              item.phoneNumber,
            ) ==
                _normalizePhoneNumber(
                  contact.phoneNumber,
                );
      },
    );

    if (contactExists) {
      return;
    }

    try {
      ContactModel? addedContact =
      await contactService
          .addContactByUserId(
        contact.id,
      );

      contacts.add(
        addedContact ?? contact,
      );

      _sortContacts();
    } catch (error) {
      errorMessage.value =
      'Failed to add contact: $error';
    }
  }

  void _sortContacts() {
    contacts.sort(
          (
          ContactModel first,
          ContactModel second,
          ) {
        int comparison = first.name
            .toLowerCase()
            .compareTo(
          second.name.toLowerCase(),
        );

        return isNameAscending.value
            ? comparison
            : -comparison;
      },
    );

    contacts.refresh();
  }

  void toggleNameSort() {
    isNameAscending.toggle();

    _sortContacts();
  }

  List<ContactModel> get filteredContacts {
    String query =
    searchQuery.value.trim().toLowerCase();

    List<ContactModel> result =
    contacts.where(
          (ContactModel contact) {
        return !contact.isBlocked;
      },
    ).toList();

    if (query.isEmpty) {
      return result;
    }

    return result.where(
          (ContactModel contact) {
        bool matchesName = contact.name
            .toLowerCase()
            .contains(query);

        bool matchesUsername =
        contact.username
            .toLowerCase()
            .contains(query);

        bool matchesPhone =
        contact.phoneNumber
            .toLowerCase()
            .contains(query);

        return matchesName ||
            matchesUsername ||
            matchesPhone;
      },
    ).toList();
  }

  Map<String, List<ContactModel>>
  get groupedContacts {
    Map<String, List<ContactModel>> grouped =
    <String, List<ContactModel>>{};

    for (ContactModel contact
    in filteredContacts) {
      String cleanName = contact.name.trim();

      if (cleanName.isEmpty) {
        continue;
      }

      String firstLetter =
      cleanName[0].toUpperCase();

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
          int comparison = first.name
              .toLowerCase()
              .compareTo(
            second.name.toLowerCase(),
          );

          return isNameAscending.value
              ? comparison
              : -comparison;
        },
      );
    }

    return grouped;
  }

  List<String> get contactLetters {
    List<String> letters =
    groupedContacts.keys.toList();

    letters.sort();

    if (!isNameAscending.value) {
      letters = letters.reversed.toList();
    }

    return letters;
  }

  int get onlineContactCount {
    return contacts.where(
          (ContactModel contact) {
        return contact.status ==
            ContactStatus.online &&
            !contact.isBlocked;
      },
    ).length;
  }

  int get favoriteContactCount {
    return contacts.where(
          (ContactModel contact) {
        return contact.isFavorite &&
            !contact.isBlocked;
      },
    ).length;
  }

  Future<void> toggleFavorite(
      ContactModel contact,
      ) async {
    try {
      ContactModel? updated =
      await contactService.toggleFavorite(
        contact.id,
      );

      if (updated == null) {
        return;
      }

      _replaceContact(updated);
    } catch (error) {
      errorMessage.value =
      'Failed to update favorite: $error';
    }
  }

  Future<void> blockContact(
      ContactModel contact,
      ) async {
    await _updateBlocked(
      contactId: contact.id,
      isBlocked: true,
    );
  }

  Future<void> unblockContact(
      ContactModel contact,
      ) async {
    await _updateBlocked(
      contactId: contact.id,
      isBlocked: false,
    );
  }

  Future<void> _updateBlocked({
    required String contactId,
    required bool isBlocked,
  }) async {
    try {
      ContactModel? updated =
      await contactService.updateBlocked(
        contactId: contactId,
        isBlocked: isBlocked,
      );

      if (updated == null) {
        return;
      }

      _replaceContact(updated);
    } catch (error) {
      errorMessage.value =
      'Failed to update contact: $error';
    }
  }

  void _replaceContact(
      ContactModel updatedContact,
      ) {
    int index = contacts.indexWhere(
          (ContactModel contact) {
        return contact.id ==
            updatedContact.id;
      },
    );

    if (index < 0) {
      contacts.add(updatedContact);
    } else {
      contacts[index] = updatedContact;
    }

    _sortContacts();
  }

  void openContact(
      ContactModel contact,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    ChatModel chat = ChatModel(
      id: contact.id,
      name: contact.name,
      message: '',
      dateTime: DateTime.now(),
      image: contact.avatarUrl,
      unread: 0,
      type: 'personal',
      isPinned: false,
      isMuted: false,
      isOnline:
      contact.status == ContactStatus.online,
      isTyping: false,
      isMe: false,
      isArchived: false,
      status: MessageStatus.read,
    );

    Get.to(
          () => ChatDetailScreen(
        chat: chat,
      ),
      transition: Transition.cupertino,
      duration: Duration(
        milliseconds: 280,
      ),
    );
  }

  Future<void> removeContact(
      ContactModel contact,
      ) async {
    try {
      await contactService.removeContact(
        contact.id,
      );

      contacts.removeWhere(
            (ContactModel item) {
          return item.id == contact.id;
        },
      );
    } catch (error) {
      errorMessage.value =
      'Failed to remove contact: $error';
    }
  }

  String _normalizePhoneNumber(
      String phoneNumber,
      ) {
    return phoneNumber.replaceAll(
      RegExp(r'[^0-9+]'),
      '',
    );
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