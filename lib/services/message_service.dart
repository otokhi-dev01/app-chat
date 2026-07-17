import '../../models/chat_message_model.dart';

abstract class MessageService {
  Future<List<ChatMessageModel>> getMessages(
      String chatId,
      );

  Future<ChatMessageModel?> getMessageById({
    required String chatId,
    required String messageId,
  });

  Future<ChatMessageModel> sendTextMessage({
    required String chatId,
    required String text,
  });

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  });

  Future<ChatMessageModel?> markMessageRead({
    required String chatId,
    required String messageId,
  });
}