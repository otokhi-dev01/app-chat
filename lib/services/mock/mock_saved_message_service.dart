import 'package:appchat/services/save_message_service.dart';
import '../../../models/chat_message_model.dart';
import '../../../models/save_message_model.dart';
import '../../data/mock_chat_database.dart';
import '../message_service.dart';
import 'mock_service_delay.dart';

class MockSavedMessageService
    with MockServiceDelay
    implements SavedMessageService {
  final MessageService messageService;

  MockSavedMessageService({
    required this.messageService,
  });

  @override
  Future<List<SavedMessageModel>>
  getSavedMessages() async {
    await simulateDelay();

    return MockChatDatabase.savedMessages;
  }

  @override
  Future<SavedMessageModel>
  sendSavedMessage(
      String text,
      ) async {
    ChatMessageModel message =
    await messageService.sendTextMessage(
      chatId: MockChatDatabase.savedChatId,
      text: text,
    );

    return SavedMessageModel(
      id: message.id,
      text: message.displayText,
      dateTime: message.sentAt,
    );
  }

  @override
  Future<void> deleteSavedMessage(
      String messageId,
      ) async {
    await messageService.deleteMessage(
      chatId: MockChatDatabase.savedChatId,
      messageId: messageId,
    );
  }
}