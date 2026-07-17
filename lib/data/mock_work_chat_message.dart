import '../../../models/chat_message_model.dart';
import 'mock_ids.dart';

class MockWorkChatMessages {
  static List<ChatMessageModel> build() {
    DateTime now = DateTime.now();

    return [
      ChatMessageModel(
        id: 'work_message_001',
        localId: 'local_work_001',
        conversationId: MockIds.officeChatId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text: 'What time is the meeting?',
        sentAt: now.subtract(
          Duration(
            hours: 1,
            minutes: 20,
          ),
        ),
        deliveredAt: now.subtract(
          Duration(
            hours: 1,
            minutes: 20,
          ),
        ),
        readAt: now.subtract(
          Duration(
            hours: 1,
            minutes: 18,
          ),
        ),
        isMe: true,
        isRead: true,
        type: ChatMessageType.text,
        status: ChatMessageStatus.read,
      ),
      ChatMessageModel(
        id: 'work_message_002',
        localId: 'local_work_002',
        conversationId: MockIds.officeChatId,
        senderId: MockIds.brianUserId,
        senderName: 'Brian Cooper',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_004',
        text:
        'The meeting starts at 3:00 PM.',
        sentAt: now.subtract(
          Duration(hours: 1),
        ),
        deliveredAt: now.subtract(
          Duration(hours: 1),
        ),
        isMe: false,
        isRead: false,
        type: ChatMessageType.text,
        status: ChatMessageStatus.delivered,
      ),
    ];
  }
}