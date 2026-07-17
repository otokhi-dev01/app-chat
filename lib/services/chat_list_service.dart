import '../models/chat_model.dart';
import '../models/user_model.dart';

abstract class ChatListService {
  Future<List<ChatModel>> getChats();

  Future<List<ChatModel>> getArchivedChats();

  Future<ChatModel?> getChatById(
      String chatId,
      );

  Future<List<AppUserModel>> getChatMembers(
      String chatId,
      );

  Future<void> markChatRead(
      String chatId,
      );

  Future<ChatModel?> markChatUnread(
      String chatId,
      );

  Future<void> markAllChatsRead();

  Future<void> archiveChat(
      String chatId,
      );

  Future<void> unarchiveChat(
      String chatId,
      );

  Future<ChatModel?> togglePinned(
      String chatId,
      );

  Future<ChatModel?> toggleMuted(
      String chatId,
      );

  Future<void> deleteChat(
      String chatId,
      );

  Future<void> clearChats();
}