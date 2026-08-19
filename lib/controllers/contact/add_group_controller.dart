import 'dart:io';

import 'package:get/get.dart';

import '../chat/chat_controller.dart';
import '../../models/contact_model.dart';
import '../../services/chat_service/group_chat_api_service.dart';
import 'contact_controller.dart';

class AddGroupController extends GetxController {
  final GroupChatApiService groupChatApiService;

  AddGroupController({
    required this.groupChatApiService,
  });
  final RxList<ContactModel> contacts =
      <ContactModel>[].obs;

  final RxList<ContactModel> selectedMembers =
      <ContactModel>[].obs;

  final Set<String> _selectedMemberIds =
  <String>{};

  final RxString groupName = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString groupImagePath = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString loadErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadContacts();
  }

  void setGroupName(
      String value,
      ) {
    groupName.value = value.trim();
    errorMessage.value = '';
  }

  void setSearchQuery(
      String value,
      ) {
    searchQuery.value = value.trim();
  }

  void clearSearchQuery() {
    searchQuery.value = '';
  }

  Future<void> loadContacts() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    loadErrorMessage.value = '';

    try {
      List<ContactModel> result =
      Get.find<ContactController>().contacts
          .where(
            (ContactModel contact) {
          return !contact.isBlocked;
        },
      )
          .toList(
        growable: false,
      );

      contacts.assignAll(
        result,
      );
    } catch (error) {
      loadErrorMessage.value =
      'Unable to load contacts.';
    } finally {
      isLoading.value = false;
    }
  }

  List<ContactModel> get filteredContacts {
    String query =
    searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      return contacts;
    }

    return contacts.where(
          (ContactModel contact) {
        String name =
        contact.name.toLowerCase();

        String username =
        contact.username.toLowerCase();

        String phoneNumber =
        contact.phoneNumber.toLowerCase();

        return name.contains(query) ||
            username.contains(query) ||
            phoneNumber.contains(query);
      },
    ).toList(
      growable: false,
    );
  }

  bool isSelected(
      ContactModel contact,
      ) {
    return _selectedMemberIds.contains(
      contact.id,
    );
  }

  void toggleMember(
      ContactModel contact,
      ) {
    bool alreadySelected =
    _selectedMemberIds.contains(
      contact.id,
    );

    if (alreadySelected) {
      _selectedMemberIds.remove(
        contact.id,
      );

      selectedMembers.removeWhere(
            (ContactModel member) {
          return member.id == contact.id;
        },
      );
    } else {
      _selectedMemberIds.add(
        contact.id,
      );

      selectedMembers.add(
        contact,
      );
    }

    update(
      <Object>[
        'contact_${contact.id}',
      ],
    );
  }

  void removeMember(
      ContactModel contact,
      ) {
    bool removed =
    _selectedMemberIds.remove(
      contact.id,
    );

    if (!removed) {
      return;
    }

    selectedMembers.removeWhere(
          (ContactModel member) {
        return member.id == contact.id;
      },
    );

    update(
      <Object>[
        'contact_${contact.id}',
      ],
    );
  }

  void setGroupImage(
      String imagePath,
      ) {
    groupImagePath.value =
        imagePath.trim();
  }

  void removeGroupImage() {
    groupImagePath.value = '';
  }

  bool get canCreateGroup {
    return groupName.value.isNotEmpty &&
        selectedMembers.isNotEmpty &&
        !isCreating.value;
  }

  String get memberCountText {
    int count = selectedMembers.length;

    if (count == 0) {
      return 'Select at least one member';
    }

    if (count == 1) {
      return '1 member selected';
    }

    return '$count members selected';
  }

  Future<bool> createGroup() async {
    if (groupName.value.isEmpty) {
      errorMessage.value =
      'Please enter a group name.';

      return false;
    }

    if (selectedMembers.isEmpty) {
      errorMessage.value =
      'Please select at least one member.';

      return false;
    }

    if (isCreating.value) {
      return false;
    }

    isCreating.value = true;
    errorMessage.value = '';

    try {
      final memberIds = selectedMembers.map((member) => member.contactUserId).toList();
      File? imageFile;
      
      if (groupImagePath.value.isNotEmpty) {
        imageFile = File(groupImagePath.value);
      }

      final chat = await groupChatApiService.createGroup(
        name: groupName.value,
        memberIds: memberIds,
        groupImage: imageFile,
      );

      // Refresh home chat list if controller is active
      if (Get.isRegistered<ChatController>()) {
        await Get.find<ChatController>().loadChats();
      }

      Get.back(result: chat);

      return true;
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isCreating.value = false;
    }
  }
}