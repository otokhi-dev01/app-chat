import '../../../models/chat_message_model.dart';
import 'mock_ids.dart';

class MockGroupChatMessages {
  static List<ChatMessageModel> build() {
    DateTime now = DateTime.now();

    return [
      ChatMessageModel(
        id: 'group_message_001',
        localId: 'local_group_001',
        conversationId:
        MockIds.appChatGroupId,
        senderId: 'system',
        senderName: 'AppChat',
        senderAvatar: '',
        text:
        'Alex Morgan created the group.',
        sentAt: now.subtract(
          Duration(hours: 3),
        ),
        isMe: false,
        isRead: true,
        type: ChatMessageType.system,
        status: ChatMessageStatus.read,
      ),
      ChatMessageModel(
        id: 'group_message_002',
        localId: 'local_group_002',
        conversationId:
        MockIds.appChatGroupId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text: 'Good morning team.',
        sentAt: now.subtract(
          Duration(hours: 2),
        ),
        deliveredAt: now.subtract(
          Duration(hours: 2),
        ),
        readAt: now.subtract(
          Duration(
            hours: 1,
            minutes: 58,
          ),
        ),
        isMe: true,
        isRead: true,
        type: ChatMessageType.text,
        status: ChatMessageStatus.read,
        reactions: {
          '👍': 3,
          '❤️': 1,
        },
        myReaction: '👍',
      ),
      ChatMessageModel(
        id: 'group_message_003',
        localId: 'local_group_003',
        conversationId:
        MockIds.appChatGroupId,
        senderId: MockIds.chloeUserId,
        senderName: 'Chloe Bennett',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_005',
        text: '',
        sentAt: now.subtract(
          Duration(minutes: 50),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 50),
        ),
        isMe: false,
        isRead: false,
        type: ChatMessageType.contact,
        status: ChatMessageStatus.delivered,
        contactName: 'Daniel Kim',
        contactPhoneNumber:
        '+855 15 555 002',
        contactUserId: MockIds.danielUserId,
      ),
      ChatMessageModel(
        id: 'group_message_004',
        localId: 'local_group_004',
        conversationId:
        MockIds.appChatGroupId,
        senderId: MockIds.amandaUserId,
        senderName: 'Amanda Lee',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_003',
        text: 'I pushed the API update.',
        sentAt: now.subtract(
          Duration(minutes: 8),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 8),
        ),
        isMe: false,
        isRead: false,
        type: ChatMessageType.text,
        status: ChatMessageStatus.delivered,
        reactions: {
          '🔥': 2,
        },
      ),
    ];
  }
}