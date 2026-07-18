import '../../../models/chat_message_model.dart';
import '../../../models/user_model.dart';
import '../../data/mock_chat_database.dart';
import '../message_service.dart';
import 'mock_service_delay.dart';

class MockMessageService
    with MockServiceDelay
    implements MessageService {
  @override
  Future<List<ChatMessageModel>> getMessages(
      String chatId,
      ) async {
    await simulateDelay();

    return MockChatDatabase.getMessages(
      chatId,
    );
  }

  @override
  Future<ChatMessageModel?> getMessageById({
    required String chatId,
    required String messageId,
  }) async {
    await simulateDelay();

    List<ChatMessageModel> messages =
        MockChatDatabase.messages[chatId] ??
            <ChatMessageModel>[];

    int index = messages.indexWhere(
          (ChatMessageModel message) {
        return message.id == messageId;
      },
    );

    if (index < 0) {
      return null;
    }

    return messages[index];
  }

  @override
  Future<ChatMessageModel> sendTextMessage({
    required String chatId,
    required String text,
  }) async {
    String cleanText = text.trim();

    if (cleanText.isEmpty) {
      throw ArgumentError(
        'Message cannot be empty.',
      );
    }

    AppUserModel? currentUser =
        MockChatDatabase.currentProfile;

    String timestamp = DateTime.now()
        .microsecondsSinceEpoch
        .toString();

    await simulateDelay();

    ChatMessageModel message =
    ChatMessageModel(
      id: 'message_$timestamp',
      localId: 'local_$timestamp',
      conversationId: chatId,
      senderId:
      MockChatDatabase.currentUserId,
      senderName:
      currentUser?.name ?? 'Current user',
      senderAvatar:
      currentUser?.avatarUrl ?? '',
      text: cleanText,
      sentAt: DateTime.now(),
      isMe: true,
      isRead: false,
      type: ChatMessageType.text,
      status: ChatMessageStatus.sent,
    );

    MockChatDatabase.addMessage(
      chatId: chatId,
      message: message,
    );

    return message;
  }

  @override
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    await simulateDelay();

    MockChatDatabase.deleteMessage(
      chatId: chatId,
      messageId: messageId,
    );
  }

  @override
  Future<ChatMessageModel?> markMessageRead({
    required String chatId,
    required String messageId,
  }) async {
    await simulateDelay();

    List<ChatMessageModel>? messages =
    MockChatDatabase.messages[chatId];

    if (messages == null) {
      return null;
    }

    int index = messages.indexWhere(
          (ChatMessageModel message) {
        return message.id == messageId;
      },
    );

    if (index < 0) {
      return null;
    }

    ChatMessageModel updated =
    messages[index].copyWith(
      status: ChatMessageStatus.read,
      isRead: true,
      readAt: DateTime.now(),
    );

    messages[index] = updated;

    return updated;
  }
}