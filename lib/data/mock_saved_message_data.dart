import '../../models/chat_message_model.dart';
import '../../models/save_message_model.dart';

class MockSavedMessageData {
  static List<SavedMessageModel> fromMessages(
      List<ChatMessageModel> messages,
      ) {
    return messages.map(
          (ChatMessageModel message) {
        return SavedMessageModel(
          id: message.id,
          text: message.displayText,
          dateTime: message.sentAt,
        );
      },
    ).toList();
  }
}