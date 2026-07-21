import '../models/chat_folder_model.dart';

abstract class ChatFolderService {
  Future<List<ChatFolderModel>> getFolders();

  Future<ChatFolderModel?> createFolder({
    required String name,
    List<String>? chatIds,
  });

  Future<ChatFolderModel?> updateFolder({
    required String folderId,
    required String name,
  });

  Future<bool> deleteFolder({
    required String folderId,
  });

  Future<List<ChatFolderModel>> resetFolders();
}