import '../../../models/chat_message_model.dart';
import '../../../models/chat_model.dart';

List<ChatMessageModel> buildChatSampleMessages(
    ChatModel chat,
    ) {
  DateTime now = DateTime.now();

  return [
    ChatMessageModel(
      id: 'message-1',
      text: 'Hello! How are you?',
      sentAt: now.subtract(
        Duration(minutes: 24),
      ),
      isMe: false,
    ),
    ChatMessageModel(
      id: 'message-2',
      text:
      'I am doing well. I am currently working on the chat application.',
      sentAt: now.subtract(
        Duration(minutes: 21),
      ),
      isMe: true,
      isRead: true,
    ),
    ChatMessageModel(
      id: 'message-3',
      text: 'That sounds great. How is it going?',
      sentAt: now.subtract(
        Duration(minutes: 18),
      ),
      isMe: false,
    ),
    ChatMessageModel(
      id: 'message-4',
      text: chat.message,
      sentAt: chat.dateTime,
      isMe: chat.isMe,
      isRead: true,
    ),
  ];
}