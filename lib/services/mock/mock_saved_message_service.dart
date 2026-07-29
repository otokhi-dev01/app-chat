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
  Future<SavedMessageModel>
  sendSavedMedia(
      SavedMessageModel draft,
      ) async {
    await simulateDelay();

    // Re-stamped with the saved-chat id and a fresh timestamp/id so it
    // behaves the same way sendSavedMessage does — draft.id from the
    // camera/file/voice service is only a local placeholder.
    SavedMessageModel saved = SavedMessageModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      text: draft.text,
      dateTime: DateTime.now(),
      conversationId:
      MockChatDatabase.savedChatId,
      type: draft.type,
      status: draft.status,
      isRead: true,
      mediaPath: draft.mediaPath,
      latitude: draft.latitude,
      longitude: draft.longitude,
    );

    MockChatDatabase.savedMessages.add(
      saved,
    );

    return saved;
  }

  @override
  Future<void> deleteSavedMessage(
      String messageId,
      ) async {
    await messageService.deleteMessage(
      chatId: MockChatDatabase.savedChatId,
      messageId: messageId,
    );

    // Keeps the in-memory saved list consistent with the underlying
    // message store — without this, a deleted media message would
    // still show up next time getSavedMessages() is called.
    MockChatDatabase.savedMessages.removeWhere(
          (SavedMessageModel item) {
        return item.id == messageId;
      },
    );
  }
}