import '../../models/chat_message_model.dart';
import '../../models/chat_model.dart';
import '../../models/contact_model.dart';
import '../../models/save_message_model.dart';
import '../../models/user_model.dart';
import '../chat_data_service.dart';

class MockChatDataService implements ChatDataService {
  @override
  Future<AppUserModel?> getCurrentProfile() async {
    await Future<void>.delayed(
      Duration(milliseconds: 200),
    );

    return null;
  }

  @override
  Future<List<AppUserModel>> getUsers() async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    return <AppUserModel>[];
  }

  @override
  Future<List<ContactModel>> getContacts() async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    return <ContactModel>[];
  }

  @override
  Future<List<ChatModel>> getChats() async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    return <ChatModel>[];
  }

  @override
  Future<List<ChatModel>> getArchivedChats() async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    return <ChatModel>[];
  }

  @override
  Future<List<ChatMessageModel>> getMessages(
      String chatId,
      ) async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    return <ChatMessageModel>[];
  }

  @override
  Future<List<SavedMessageModel>> getSavedMessages() async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    return <SavedMessageModel>[];
  }

  @override
  Future<List<AppUserModel>> getChatMembers(
      String chatId,
      ) async {
    await Future<void>.delayed(
      Duration(milliseconds: 300),
    );

    return <AppUserModel>[];
  }

  @override
  Future<ChatMessageModel> sendTextMessage({
    required String chatId,
    required String text,
  }) async {
    await Future<void>.delayed(
      Duration(milliseconds: 400),
    );

    throw UnimplementedError(
      'Add your ChatMessageModel constructor here.',
    );
  }

  @override
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    await Future<void>.delayed(
      Duration(milliseconds: 250),
    );
  }

  @override
  Future<void> markChatRead(
      String chatId,
      ) async {
    await Future<void>.delayed(
      Duration(milliseconds: 200),
    );
  }

  @override
  Future<void> archiveChat(
      String chatId,
      ) async {
    await Future<void>.delayed(
      Duration(milliseconds: 250),
    );
  }

  @override
  Future<void> unarchiveChat(
      String chatId,
      ) async {
    await Future<void>.delayed(
      Duration(milliseconds: 250),
    );
  }
}