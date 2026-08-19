import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/model/chat_folder_member_model.dart';
import '../../models/chat_folder_model.dart';
import '../../services/folder_service/chat_folder_api_service.dart';
import '../chat/chat_controller.dart';

class ChatFolderController extends GetxController {
  final ChatFolderApiService chatFolderApiService;

  ChatFolderController({
    required this.chatFolderApiService,
  });

  final RxList<ChatFolderModel> folders =
      <ChatFolderModel>[].obs;

  final RxList<ChatFolderMemberModel> memberOptions =
      <ChatFolderMemberModel>[].obs;

  final RxSet<String> selectedChatIds =
      <String>{}.obs;

  final RxSet<String> selectedMemberIds =
      <String>{}.obs;

  final Rxn<ChatFolderModel> selectedFolder =
  Rxn<ChatFolderModel>();

  final RxString memberSearch = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isLoadingMembers = false.obs;

  Worker? _memberSearchWorker;

  @override
  void onInit() {
    super.onInit();

    _memberSearchWorker = debounce<String>(
      memberSearch,
          (value) {
        loadMemberOptions(search: value);
      },
      time: const Duration(milliseconds: 500),
    );

    loadFolders();
  }

  @override
  void onClose() {
    _memberSearchWorker?.dispose();
    super.onClose();
  }

  Future<void> loadFolders() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result =
      await chatFolderApiService.getFolders();

      folders.assignAll(result);
    } catch (error) {
      errorMessage.value = _errorText(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMemberOptions({
    String search = '',
  }) async {
    try {
      isLoadingMembers.value = true;
      errorMessage.value = '';

      final result = await chatFolderApiService
          .getMemberOptions(
        search: search,
      );

      memberOptions.assignAll(result);
    } catch (error) {
      memberOptions.clear();
      errorMessage.value = _errorText(error);
    } finally {
      isLoadingMembers.value = false;
    }
  }

  void onMemberSearchChanged(String value) {
    memberSearch.value = value.trim();
  }

  void selectFolder(ChatFolderModel folder) {
    selectedFolder.value = folder;

    selectedChatIds.assignAll(
      folder.chatIds,
    );

    selectedMemberIds.clear();
  }

  void toggleChat(String chatId) {
    if (selectedChatIds.contains(chatId)) {
      selectedChatIds.remove(chatId);
    } else {
      selectedChatIds.add(chatId);
    }
  }

  void toggleMember(String memberId) {
    if (selectedMemberIds.contains(memberId)) {
      selectedMemberIds.remove(memberId);
    } else {
      selectedMemberIds.add(memberId);
    }
  }

  bool isChatSelected(String chatId) {
    return selectedChatIds.contains(chatId);
  }

  bool isMemberSelected(String memberId) {
    return selectedMemberIds.contains(memberId);
  }

  Future<bool> createFolder({
    required String name,
    List<String>? chatIds,
    List<String>? memberIds,
  }) async {
    if (name.trim().isEmpty) {
      errorMessage.value =
      'Please enter a folder name.';
      return false;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final folder =
      await chatFolderApiService.createFolder(
        name: name,
        chatIds: chatIds ?? selectedChatIds.toList(),
        memberIds: memberIds ?? selectedMemberIds.toList(),
      );

      folders.add(folder);
      selectedFolder.value = folder;

      successMessage.value =
      'Chat folder created successfully.';

      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().loadChats();
      }

      debugPrint('✅ createFolder success: folder ${folder.id} created.');
      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      debugPrint('❌ createFolder error: $error');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateFolder({
    required String folderId,
    String? name,
    bool updateSelection = true,
    List<String>? chatIds,
    List<String>? memberIds,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final updatedFolder =
      await chatFolderApiService.updateFolder(
        folderId: folderId,
        name: name,
        chatIds: updateSelection
            ? (chatIds ?? selectedChatIds.toList())
            : null,
        memberIds: updateSelection
            ? (memberIds ?? selectedMemberIds.toList())
            : null,
      );

      final index = folders.indexWhere(
            (folder) => folder.id == folderId,
      );

      if (index >= 0) {
        folders[index] = updatedFolder;
      }

      selectedFolder.value = updatedFolder;

      successMessage.value =
      'Chat folder updated successfully.';

      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().loadChats();
      }

      debugPrint('✅ updateFolder success: folder $folderId updated.');
      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      debugPrint('❌ updateFolder error: $error');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteFolder(
      ChatFolderModel folder,
      ) async {
    if (folder.isSystem) {
      errorMessage.value =
      'System folders cannot be deleted.';
      return false;
    }

    try {
      isDeleting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final message =
      await chatFolderApiService.deleteFolder(
        folder.id,
      );

      folders.removeWhere(
            (item) => item.id == folder.id,
      );

      if (selectedFolder.value?.id == folder.id) {
        selectedFolder.value = null;
      }

      clearSelection();
      successMessage.value = message;

      debugPrint('✅ deleteFolder success: folder ${folder.id} deleted.');
      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      debugPrint('❌ deleteFolder error: $error');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  void clearSelection() {
    selectedChatIds.clear();
    selectedMemberIds.clear();
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  String _errorText(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('FormatException: ', '');
  }
}