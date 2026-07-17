import '../models/chat_message_model.dart';
import '../models/chat_model.dart';
import '../models/contact_model.dart';
import '../models/save_message_model.dart';
import '../models/user_model.dart';

abstract class ChatDataService {
  Future<AppUserModel?> getCurrentProfile();

  Future<List<AppUserModel>> getUsers();

  Future<List<ContactModel>> getContacts();

  Future<List<ChatModel>> getChats();

  Future<List<ChatModel>> getArchivedChats();

  Future<List<ChatMessageModel>> getMessages(
      String chatId,
      );

  Future<List<SavedMessageModel>>
  getSavedMessages();

  Future<List<AppUserModel>> getChatMembers(
      String chatId,
      );

  Future<ChatMessageModel> sendTextMessage({
    required String chatId,
    required String text,
  });

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  });

  Future<void> markChatRead(
      String chatId,
      );

  Future<void> archiveChat(
      String chatId,
      );

  Future<void> unarchiveChat(
      String chatId,
      );
}