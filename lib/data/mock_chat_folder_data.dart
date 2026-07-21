import '../../models/chat_folder_model.dart';

class MockChatFolderData {
  static List<ChatFolderModel> get defaultFolders {
    return <ChatFolderModel>[
      ChatFolderModel(
        id: 'folder_all',
        name: 'All Chats',
        type: ChatFolderType.all,
        chatCount: 34,
        isSystem: true,
      ),
      ChatFolderModel(
        id: 'folder_personal',
        name: 'Personal',
        type: ChatFolderType.personal,
        chatCount: 18,
        isSystem: true,
      ),
    ];
  }

  static List<ChatFolderModel> get customFolders {
    return <ChatFolderModel>[
      ChatFolderModel(
        id: 'folder_work',
        name: 'Work',
        type: ChatFolderType.custom,
        chatCount: 3,
        isSystem: false,
        chatIds: <String>[
          'chat_001',
          'chat_004',
          'chat_007',
        ],
      ),
      ChatFolderModel(
        id: 'folder_family',
        name: 'Family',
        type: ChatFolderType.custom,
        chatCount: 2,
        isSystem: false,
        chatIds: <String>[
          'chat_002',
          'chat_005',
        ],
      ),
      ChatFolderModel(
        id: 'folder_school',
        name: 'School',
        type: ChatFolderType.custom,
        chatCount: 2,
        isSystem: false,
        chatIds: <String>[
          'chat_003',
          'chat_006',
        ],
      ),
    ];
  }
}