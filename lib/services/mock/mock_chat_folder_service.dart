import '../../data/mock_chat_folder_data.dart';
import '../../models/chat_folder_model.dart';
import '../chat_folder_service.dart';

class MockChatFolderService
    implements ChatFolderService {
  late List<ChatFolderModel> _customFolders;

  MockChatFolderService() {
    _customFolders =
        _createInitialCustomFolders();
  }

  List<ChatFolderModel>
  _createInitialCustomFolders() {
    return MockChatFolderData.customFolders
        .map(
          (ChatFolderModel folder) {
        return folder.copyWith(
          chatIds: List<String>.from(
            folder.chatIds,
          ),
        );
      },
    )
        .toList();
  }

  List<ChatFolderModel>
  _createDefaultFolders() {
    return MockChatFolderData.defaultFolders
        .map(
          (ChatFolderModel folder) {
        return folder.copyWith();
      },
    )
        .toList();
  }

  List<ChatFolderModel> _getAllFolders() {
    return <ChatFolderModel>[
      ..._createDefaultFolders(),
      ..._customFolders.map(
            (ChatFolderModel folder) {
          return folder.copyWith(
            chatIds: List<String>.from(
              folder.chatIds,
            ),
          );
        },
      ),
    ];
  }

  bool _folderNameExists({
    required String name,
    String? ignoredFolderId,
  }) {
    String normalizedName =
    name.trim().toLowerCase();

    return _getAllFolders().any(
          (ChatFolderModel folder) {
        if (folder.id ==
            ignoredFolderId) {
          return false;
        }

        return folder.name
            .trim()
            .toLowerCase() ==
            normalizedName;
      },
    );
  }

  @override
  Future<List<ChatFolderModel>>
  getFolders() async {
    await Future<void>.delayed(
      Duration(
        milliseconds: 250,
      ),
    );

    return _getAllFolders();
  }

  @override
  Future<ChatFolderModel?> createFolder({
    required String name,
  }) async {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      return null;
    }

    if (_folderNameExists(
      name: cleanName,
    )) {
      return null;
    }

    await Future<void>.delayed(
      Duration(
        milliseconds: 180,
      ),
    );

    ChatFolderModel folder =
    ChatFolderModel(
      id: 'folder_${DateTime.now().microsecondsSinceEpoch}',
      name: cleanName,
      type: ChatFolderType.custom,
      chatCount: 0,
      isSystem: false,
      chatIds: <String>[],
    );

    _customFolders.add(folder);

    return folder.copyWith();
  }

  @override
  Future<ChatFolderModel?> updateFolder({
    required String folderId,
    required String name,
  }) async {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      return null;
    }

    int folderIndex =
    _customFolders.indexWhere(
          (ChatFolderModel folder) {
        return folder.id == folderId;
      },
    );

    if (folderIndex < 0) {
      return null;
    }

    if (_folderNameExists(
      name: cleanName,
      ignoredFolderId: folderId,
    )) {
      return null;
    }

    await Future<void>.delayed(
      Duration(
        milliseconds: 180,
      ),
    );

    ChatFolderModel currentFolder =
    _customFolders[folderIndex];

    ChatFolderModel updatedFolder =
    currentFolder.copyWith(
      name: cleanName,
    );

    _customFolders[folderIndex] =
        updatedFolder;

    return updatedFolder.copyWith();
  }

  @override
  Future<bool> deleteFolder({
    required String folderId,
  }) async {
    int folderIndex =
    _customFolders.indexWhere(
          (ChatFolderModel folder) {
        return folder.id == folderId;
      },
    );

    if (folderIndex < 0) {
      return false;
    }

    await Future<void>.delayed(
      Duration(
        milliseconds: 180,
      ),
    );

    _customFolders.removeAt(
      folderIndex,
    );

    return true;
  }

  @override
  Future<List<ChatFolderModel>>
  resetFolders() async {
    await Future<void>.delayed(
      Duration(
        milliseconds: 200,
      ),
    );

    _customFolders =
        _createInitialCustomFolders();

    return _getAllFolders();
  }
}