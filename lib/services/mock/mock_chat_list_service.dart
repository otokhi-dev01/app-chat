import '../../data/mock_chat_database.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../chat_list_service.dart';

class MockChatListService
    implements ChatListService {
  Future<void> _simulateDelay() async {
    await Future<void>.delayed(
      Duration(milliseconds: 250),
    );
  }

  @override
  Future<List<ChatModel>> getChats() async {
    await _simulateDelay();

    List<ChatModel> result =
    MockChatDatabase.chats.where(
          (ChatModel chat) {
        return !chat.isArchived;
      },
    ).toList();

    _sortChats(result);

    return result;
  }

  @override
  Future<List<ChatModel>>
  getArchivedChats() async {
    await _simulateDelay();

    List<ChatModel> result =
    MockChatDatabase.chats.where(
          (ChatModel chat) {
        return chat.isArchived;
      },
    ).toList();

    result.sort(
          (
          ChatModel first,
          ChatModel second,
          ) {
        return second.dateTime.compareTo(
          first.dateTime,
        );
      },
    );

    return result;
  }

  @override
  Future<ChatModel?> getChatById(
      String chatId,
      ) async {
    await _simulateDelay();

    int index =
    MockChatDatabase.chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return null;
    }

    return MockChatDatabase.chats[index];
  }

  @override
  Future<List<AppUserModel>> getChatMembers(
      String chatId,
      ) async {
    await _simulateDelay();

    List<String> memberIds =
        MockChatDatabase
            .chatMemberIds[chatId]
            ?.toList() ??
            <String>[];

    return MockChatDatabase.users.where(
          (AppUserModel user) {
        return memberIds.contains(user.id);
      },
    ).toList();
  }

  @override
  Future<void> markChatRead(
      String chatId,
      ) async {
    await _simulateDelay();

    int index = _findChatIndex(chatId);

    if (index < 0) {
      return;
    }

    ChatModel chat =
    MockChatDatabase.chats[index];

    MockChatDatabase.chats[index] =
        chat.copyWith(
          unread: 0,
          status: MessageStatus.read,
        );
  }

  @override
  Future<ChatModel?> markChatUnread(
      String chatId,
      ) async {
    await _simulateDelay();

    int index = _findChatIndex(chatId);

    if (index < 0) {
      return null;
    }

    ChatModel chat =
    MockChatDatabase.chats[index];

    ChatModel updated = chat.copyWith(
      unread:
      chat.unread > 0 ? chat.unread : 1,
    );

    MockChatDatabase.chats[index] =
        updated;

    return updated;
  }

  @override
  Future<void> markAllChatsRead() async {
    await _simulateDelay();

    for (
    int index = 0;
    index < MockChatDatabase.chats.length;
    index++
    ) {
      ChatModel chat =
      MockChatDatabase.chats[index];

      if (chat.unread == 0) {
        continue;
      }

      MockChatDatabase.chats[index] =
          chat.copyWith(
            unread: 0,
            status: MessageStatus.read,
          );
    }
  }

  @override
  Future<void> archiveChat(
      String chatId,
      ) async {
    await _simulateDelay();

    int index = _findChatIndex(chatId);

    if (index < 0) {
      return;
    }

    ChatModel chat =
    MockChatDatabase.chats[index];

    MockChatDatabase.chats[index] =
        chat.copyWith(
          isArchived: true,
        );
  }

  @override
  Future<void> unarchiveChat(
      String chatId,
      ) async {
    await _simulateDelay();

    int index = _findChatIndex(chatId);

    if (index < 0) {
      return;
    }

    ChatModel chat =
    MockChatDatabase.chats[index];

    MockChatDatabase.chats[index] =
        chat.copyWith(
          isArchived: false,
        );
  }

  @override
  Future<ChatModel?> togglePinned(
      String chatId,
      ) async {
    await _simulateDelay();

    int index = _findChatIndex(chatId);

    if (index < 0) {
      return null;
    }

    ChatModel chat =
    MockChatDatabase.chats[index];

    ChatModel updated = chat.copyWith(
      isPinned: !chat.isPinned,
    );

    MockChatDatabase.chats[index] =
        updated;

    return updated;
  }

  @override
  Future<ChatModel?> toggleMuted(
      String chatId,
      ) async {
    await _simulateDelay();

    int index = _findChatIndex(chatId);

    if (index < 0) {
      return null;
    }

    ChatModel chat =
    MockChatDatabase.chats[index];

    ChatModel updated = chat.copyWith(
      isMuted: !chat.isMuted,
    );

    MockChatDatabase.chats[index] =
        updated;

    return updated;
  }

  @override
  Future<void> deleteChat(
      String chatId,
      ) async {
    await _simulateDelay();

    MockChatDatabase.chats.removeWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    MockChatDatabase.messages.remove(
      chatId,
    );

    MockChatDatabase.chatMemberIds.remove(
      chatId,
    );
  }

  @override
  Future<void> clearChats() async {
    await _simulateDelay();

    MockChatDatabase.chats.clear();
    MockChatDatabase.messages.clear();
    MockChatDatabase.chatMemberIds.clear();
  }

  int _findChatIndex(
      String chatId,
      ) {
    return MockChatDatabase.chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );
  }

  void _sortChats(
      List<ChatModel> chats,
      ) {
    chats.sort(
          (
          ChatModel first,
          ChatModel second,
          ) {
        if (first.isPinned !=
            second.isPinned) {
          return first.isPinned ? -1 : 1;
        }

        return second.dateTime.compareTo(
          first.dateTime,
        );
      },
    );
  }
}