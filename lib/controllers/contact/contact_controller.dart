import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../../models/contact_model.dart';
import '../../route/app_route.dart';
import '../../screen/chat_detail/chat_detail_screen.dart';
import '../../services/contact_service/contact_api_service.dart';

class ContactController extends GetxController {
  final ContactApiService contactApiService;

  ContactController({
    required this.contactApiService,
  });

  final RxList<ContactModel> contacts =
      <ContactModel>[].obs;

  final RxList<ContactModel> userOptions =
      <ContactModel>[].obs;

  final RxString contactSearch = ''.obs;
  final RxString userSearch = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isSearchingUsers = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  // Added for UI compatibility
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool showAddButton = true.obs;
  final RxBool isSyncingContacts = false.obs;
  final RxBool isDeletingSyncedContacts = false.obs;
  
  // Maps to contactSearch
  RxString get searchQuery => contactSearch;

  // Grouped contacts mapped to the flat list
  Map<String, List<ContactModel>> get groupedContacts {
    final map = <String, List<ContactModel>>{};
    for (var contact in contacts) {
      // Basic grouping: first letter of name (fallback to #)
      final String firstLetter = (contact.name.isNotEmpty ? contact.name : (contact.username.isNotEmpty ? contact.username : '#'))[0].toUpperCase();
      final key = RegExp(r'[A-Z]').hasMatch(firstLetter) ? firstLetter : '#';
      map.putIfAbsent(key, () => []).add(contact);
    }
    return map;
  }

  Worker? _contactSearchWorker;
  Worker? _userSearchWorker;

  @override
  void onInit() {
    super.onInit();

    _contactSearchWorker = debounce<String>(
      contactSearch,
          (search) {
        loadContacts(search: search);
      },
      time: const Duration(milliseconds: 400),
    );

    _userSearchWorker = debounce<String>(
      userSearch,
          (search) {
        searchUsers(search);
      },
      time: const Duration(milliseconds: 500),
    );

    loadContacts();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    _contactSearchWorker?.dispose();
    _userSearchWorker?.dispose();
    super.onClose();
  }

  Future<void> loadContacts({
    String search = '',
  }) async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result =
      await contactApiService.getContacts(
        search: search,
      );

      contacts.assignAll(result);
    } catch (error) {
      errorMessage.value = _errorText(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshContacts() async {
    await loadContacts(
      search: contactSearch.value,
    );
  }

  void onContactSearchChanged(String value) {
    contactSearch.value = value.trim();
  }

  void updateSearch(String value) {
    onContactSearchChanged(value);
  }

  void clearSearch() {
    searchController.clear();
    onContactSearchChanged('');
  }

  void onUserSearchChanged(String value) {
    userSearch.value = value.trim();
  }

  Future<void> searchUsers(
      String search,
      ) async {
    final normalizedSearch = search.trim();

    if (normalizedSearch.length < 2) {
      userOptions.clear();
      return;
    }

    try {
      isSearchingUsers.value = true;
      errorMessage.value = '';

      final result =
      await contactApiService.getUserOptions(
        search: normalizedSearch,
      );

      userOptions.assignAll(result);
    } catch (error) {
      userOptions.clear();
      errorMessage.value = _errorText(error);
    } finally {
      isSearchingUsers.value = false;
    }
  }

  Future<bool> addContact({
    required ContactModel user,
    String? customName,
  }) async {
    if (isSaving.value) {
      return false;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final contact =
      await contactApiService.createContact(
        contactUserId: user.contactUserId,
        name: customName,
      );

      contacts.insert(0, contact);

      userOptions.removeWhere(
            (item) =>
        item.contactUserId == contact.contactUserId,
      );

      successMessage.value =
      'Contact added successfully.';

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateContact({
    required String contactId,
    String? name,
    bool? isFavorite,
    bool? isBlocked,
  }) async {
    if (isSaving.value) {
      return false;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final updatedContact =
      await contactApiService.updateContact(
        contactId: contactId,
        name: name,
        isFavorite: isFavorite,
        isBlocked: isBlocked,
      );

      _replaceContact(updatedContact);

      successMessage.value =
      'Contact updated successfully.';

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> toggleFavorite(
      ContactModel contact,
      ) async {
    return updateContact(
      contactId: contact.id,
      isFavorite: !contact.isFavorite,
    );
  }

  Future<bool> toggleBlocked(
      ContactModel contact,
      ) async {
    return updateContact(
      contactId: contact.id,
      isBlocked: !contact.isBlocked,
    );
  }

  Future<bool> deleteContact(
      ContactModel contact,
      ) async {
    if (isDeleting.value) {
      return false;
    }

    try {
      isDeleting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final message =
      await contactApiService.deleteContact(
        contact.id,
      );

      contacts.removeWhere(
            (item) => item.id == contact.id,
      );

      successMessage.value = message;

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  // Alias for backward compatibility
  Future<bool> removeContact(ContactModel contact) => deleteContact(contact);

  void clearUserSearch() {
    userSearch.value = '';
    userOptions.clear();
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  // Dummy methods for phone contacts sync
  Future<void> syncPhoneContacts() async {
    isSyncingContacts.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isSyncingContacts.value = false;
  }

  Future<void> deleteSyncedContacts() async {
    isDeletingSyncedContacts.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isDeletingSyncedContacts.value = false;
  }

  // Navigate to chat detail screen for a contact
  void openContact(ContactModel contact) {
    final ChatModel chat = ChatModel(
      id: contact.contactUserId,
      peerUserId: contact.contactUserId,
      name: contact.name.isNotEmpty ? contact.name : contact.username,
      message: '',
      dateTime: DateTime.now(),
      type: 'personal',
      image: contact.avatarUrl,
      isOnline: false,
    );

    Get.to(
      () => ChatDetailScreen(chat: chat),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 280),
    );
  }

  void _replaceContact(
      ContactModel updatedContact,
      ) {
    final index = contacts.indexWhere(
          (contact) => contact.id == updatedContact.id,
    );

    if (index >= 0) {
      contacts[index] = updatedContact;
    }

    // Backend sorts favorite contacts first.
    contacts.sort((first, second) {
      if (first.isFavorite == second.isFavorite) {
        return 0;
      }

      return first.isFavorite ? -1 : 1;
    });
  }

  String _errorText(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('FormatException: ', '');
  }
}