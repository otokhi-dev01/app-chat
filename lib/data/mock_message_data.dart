import '../../models/chat_message_model.dart';
import 'mock_group_chat_message.dart';
import 'mock_ids.dart';
import 'mock_personal_chat_message.dart';
import 'mock_saved_chat_message.dart';
import 'mock_work_chat_message.dart';

class MockMessageData {
  static Map<String, List<ChatMessageModel>> build() {
    return <String, List<ChatMessageModel>>{
      MockIds.savedChatId:
      MockSavedChatMessages.build(),

      MockIds.alexChatId:
      MockPersonalChatMessages.build(),

      MockIds.appChatGroupId:
      MockGroupChatMessages.build(),

      MockIds.officeChatId:
      MockWorkChatMessages.build(),
    };
  }
}