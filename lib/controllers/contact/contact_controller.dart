import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../../models/contact_model.dart';
import '../../screen/chat_detail/chat_detail_screen.dart';
import '../../services/contact_service/contact_api_service.dart';
import '../../services/contact_service/phone_contact_api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../screen/widgets/app_feedback.dart'; // adjust path to match your project

class ContactController extends GetxController {
  final ContactApiService contactApiService;
  final PhoneContactApiService phoneContactApiService;

  ContactController({
    required this.contactApiService,
    required this.phoneContactApiService,
  });

  final Rx<PermissionStatus> contactsPermissionStatus =
      PermissionStatus.denied.obs;

  final RxList<ContactModel> contacts = <ContactModel>[].obs;

  final RxList<ContactModel> userOptions = <ContactModel>[].obs;

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
    final query = contactSearch.value.trim().toLowerCase();

    final filtered = query.isEmpty
        ? contacts
        : contacts.where((c) {
            return c.name.toLowerCase().contains(query) ||
                c.phoneNumber.contains(query) ||
                c.username.toLowerCase().contains(query);
          }).toList();

    for (var contact in filtered) {
      final String firstLetter = (contact.name.isNotEmpty
          ? contact.name
          : (contact.username.isNotEmpty ? contact.username : '#'))[0]
          .toUpperCase();
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
        // Refresh grouped view on search change (filtering is local)
        contacts.refresh();
      },
      time: const Duration(milliseconds: 300),
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

  /// Fetches both app contacts AND phone contacts, merges them into one list.
  Future<void> loadContacts({
    String search = '',
  }) async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        contactApiService.getContacts(search: search),
        phoneContactApiService.getPhoneContacts(),
      ]);

      final appContacts = results[0];
      final phoneContacts = results[1];

      // Merge: app contacts first, then phone-only contacts (avoid duplicates by phone number)
      final existingPhones = appContacts
          .map((c) => c.phoneNumber.trim())
          .where((p) => p.isNotEmpty)
          .toSet();

      final uniquePhoneContacts = phoneContacts
          .where((c) => !existingPhones.contains(c.phoneNumber.trim()))
          .toList();

      final merged = [...appContacts, ...uniquePhoneContacts];

      // Sort alphabetically by name
      merged.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      contacts.assignAll(merged);
    } catch (error) {
      errorMessage.value = _errorText(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshContacts() async {
    await loadContacts(search: contactSearch.value);
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

      final result = await contactApiService.getUserOptions(
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

  /// Add a registered app user as a contact.
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

      final contact = await contactApiService.createContact(
        contactUserId: user.contactUserId,
        name: customName,
      );

      contacts.insert(0, contact);

      userOptions.removeWhere(
        (item) => item.contactUserId == contact.contactUserId,
      );

      successMessage.value = 'Contact added successfully.';

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Add a phone-number-based contact via POST /api/phone-contacts.
  Future<bool> addPhoneContact({
    required String firstName,
    String? lastName,
    required String phoneNumber,
  }) async {
    if (isSaving.value) {
      return false;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final contact = await phoneContactApiService.createPhoneContact(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      // Insert and keep sorted
      contacts.add(contact);
      contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      successMessage.value = 'Contact saved.';

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Edit a raw phone contact via PATCH /api/phone-contacts/{id}.
  Future<bool> editPhoneContact({
    required ContactModel contact,
    required String firstName,
    String? lastName,
    required String phoneNumber,
  }) async {
    if (isSaving.value) {
      return false;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final realId = contact.id.replaceFirst('phone_', '');

      final updated = await phoneContactApiService.updatePhoneContact(
        contactId: realId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      // Replace in list and re-sort
      final index = contacts.indexWhere((c) => c.id == contact.id);
      if (index >= 0) {
        contacts[index] = updated;
      }
      contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      successMessage.value = 'Contact updated.';

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

      final updatedContact = await contactApiService.updateContact(
        contactId: contactId,
        name: name,
        isFavorite: isFavorite,
        isBlocked: isBlocked,
      );

      _replaceContact(updatedContact);

      successMessage.value = 'Contact updated successfully.';

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

  /// Deletes a contact — routes to the correct backend depending on whether
  /// it's a raw phone contact (id starts with 'phone_') or an app contact.
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

      if (_isPhoneContact(contact)) {
        // Strip the 'phone_' prefix to get the real backend ID
        final realId = contact.id.replaceFirst('phone_', '');
        await phoneContactApiService.deletePhoneContact(realId);
      } else {
        await contactApiService.deleteContact(contact.id);
      }

      contacts.removeWhere((item) => item.id == contact.id);

      successMessage.value = 'Contact deleted successfully.';

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

// Sync phone contacts — checks/requests permission first.
  Future<void> syncPhoneContacts() async {
    if (isSyncingContacts.value) {
      return;
    }

    try {
      isSyncingContacts.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      PermissionStatus status = await Permission.contacts.status;
      contactsPermissionStatus.value = status;

      if (status.isDenied) {
        status = await Permission.contacts.request();
        contactsPermissionStatus.value = status;
      }

      if (status.isPermanentlyDenied || status.isRestricted) {
        _showPermissionSettingsDialog();
        return;
      }

      // Accept both full access AND limited access
      if (!status.isGranted && !status.isLimited) {
        errorMessage.value = 'Contacts permission was not granted.';
        return;
      }

      await refreshContacts();

      successMessage.value = 'Contacts synced successfully.';
    } catch (error) {
      errorMessage.value = _errorText(error);
    } finally {
      isSyncingContacts.value = false;
    }
  }

  void _showPermissionSettingsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('permission_required'.tr),
        content: Text('enable_contacts_in_settings'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('open_settings'.tr),
          ),
        ],
      ),
    );
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

  /// Returns true if the contact is a raw phone contact (not a registered app user).
  bool _isPhoneContact(ContactModel contact) {
    return contact.id.startsWith('phone_') || !contact.isRegisteredUser;
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
        return first.name.toLowerCase().compareTo(second.name.toLowerCase());
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