import '../../../models/chat_message_model.dart';
import 'mock_ids.dart';

class MockSavedChatMessages {
  static List<ChatMessageModel> build() {
    DateTime now = DateTime.now();

    return <ChatMessageModel>[
      ChatMessageModel(
        id: 'saved_message_001',
        localId: 'local_saved_001',
        conversationId: MockIds.savedChatId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text:
        'Remember to update the notification service.',
        sentAt: now.subtract(
          Duration(minutes: 35),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 35),
        ),
        readAt: now.subtract(
          Duration(minutes: 35),
        ),
        isMe: true,
        isRead: true,
        type: ChatMessageType.text,
        status: ChatMessageStatus.read,
      ),
      ChatMessageModel(
        id: 'saved_message_002',
        localId: 'local_saved_002',
        conversationId: MockIds.savedChatId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text: '',
        sentAt: now.subtract(
          Duration(minutes: 20),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 20),
        ),
        readAt: now.subtract(
          Duration(minutes: 20),
        ),
        isMe: true,
        isRead: true,
        type: ChatMessageType.file,
        status: ChatMessageStatus.read,
        mediaPath:
        'https://example.com/files/chat-schema.pdf',
        fileName: 'chat-schema.pdf',
        mimeType: 'application/pdf',
        fileSizeBytes: 340000,
      ),
      ChatMessageModel(
        id: 'saved_message_003',
        localId: 'local_saved_003',
        conversationId: MockIds.savedChatId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text:
        'Review WebSocket reconnection flow.',
        sentAt: now.subtract(
          Duration(minutes: 12),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 12),
        ),
        readAt: now.subtract(
          Duration(minutes: 12),
        ),
        isMe: true,
        isRead: true,
        isPinned: true,
        type: ChatMessageType.text,
        status: ChatMessageStatus.read,
      ),
    ];
  }
}