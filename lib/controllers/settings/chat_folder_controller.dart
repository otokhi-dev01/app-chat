import 'package:get/get.dart';

import '../../models/chat_folder_model.dart';
import '../../services/chat_folder_service.dart';

class ChatFolderController
    extends GetxController {
  final ChatFolderService folderService;

  ChatFolderController({
    required this.folderService,
  });

  final RxList<ChatFolderModel> folders =
      <ChatFolderModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  final RxString errorMessage = ''.obs;

  List<ChatFolderModel>
  get defaultFolders {
    return folders
        .where(
          (ChatFolderModel folder) {
        return folder.isSystem;
      },
    )
        .toList();
  }

  List<ChatFolderModel>
  get customFolders {
    return folders
        .where(
          (ChatFolderModel folder) {
        return !folder.isSystem;
      },
    )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();

    loadFolders();
  }

  Future<void> loadFolders() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      List<ChatFolderModel> result =
      await folderService.getFolders();

      folders.assignAll(result);
    } catch (error) {
      errorMessage.value =
      'Unable to load chat folders.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addFolder(
    String name, {
    List<String>? chatIds,
  }) async {
    String cleanName = name.trim();

    if (cleanName.isEmpty ||
        isSaving.value) {
      return false;
    }

    isSaving.value = true;
    errorMessage.value = '';

    try {
      ChatFolderModel? folder =
      await folderService.createFolder(
        name: cleanName,
        chatIds: chatIds,
      );

      if (folder == null) {
        errorMessage.value =
        'A folder with this name already exists.';

        return false;
      }

      folders.add(folder);

      return true;
    } catch (error) {
      errorMessage.value =
      'Unable to create folder.';

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateFolder({
    required String folderId,
    required String name,
  }) async {
    String cleanName = name.trim();

    if (cleanName.isEmpty ||
        isSaving.value) {
      return false;
    }

    int index = folders.indexWhere(
          (ChatFolderModel folder) {
        return folder.id == folderId;
      },
    );

    if (index < 0) {
      return false;
    }

    ChatFolderModel currentFolder =
    folders[index];

    // Default folders cannot be edited.
    if (currentFolder.isSystem) {
      errorMessage.value =
      'Default folders cannot be edited.';

      return false;
    }

    isSaving.value = true;
    errorMessage.value = '';

    try {
      ChatFolderModel? updatedFolder =
      await folderService.updateFolder(
        folderId: folderId,
        name: cleanName,
      );

      if (updatedFolder == null) {
        errorMessage.value =
        'A folder with this name already exists.';

        return false;
      }

      folders[index] = updatedFolder;

      return true;
    } catch (error) {
      errorMessage.value =
      'Unable to update folder.';

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteFolder(
      String folderId,
      ) async {
    int index = folders.indexWhere(
          (ChatFolderModel folder) {
        return folder.id == folderId;
      },
    );

    if (index < 0) {
      return false;
    }

    ChatFolderModel folder =
    folders[index];

    // Default folders cannot be deleted.
    if (folder.isSystem) {
      errorMessage.value =
      'Default folders cannot be deleted.';

      return false;
    }

    bool deleted =
    await folderService.deleteFolder(
      folderId: folderId,
    );

    if (!deleted) {
      errorMessage.value =
      'Unable to delete folder.';

      return false;
    }

    folders.removeAt(index);

    return true;
  }

  Future<void> resetFolders() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      List<ChatFolderModel> result =
      await folderService.resetFolders();

      folders.assignAll(result);
    } catch (error) {
      errorMessage.value =
      'Unable to reset folders.';
    } finally {
      isLoading.value = false;
    }
  }
}