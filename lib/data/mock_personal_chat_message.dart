import '../../../models/chat_message_model.dart';
import 'mock_ids.dart';

class MockPersonalChatMessages {
  static List<ChatMessageModel> build() {
    DateTime now = DateTime.now();

    return [
      ChatMessageModel(
        id: 'alex_message_001',
        localId: 'local_alex_001',
        conversationId: MockIds.alexChatId,
        senderId: MockIds.alexUserId,
        senderName: 'Alex Morgan',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_002',
        text: 'Hello Vuthul, how are you?',
        sentAt: now.subtract(
          Duration(minutes: 35),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 35),
        ),
        readAt: now.subtract(
          Duration(minutes: 34),
        ),
        isMe: false,
        isRead: true,
        type: ChatMessageType.text,
        status: ChatMessageStatus.read,
      ),
      ChatMessageModel(
        id: 'alex_message_002',
        localId: 'local_alex_002',
        conversationId: MockIds.alexChatId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text:
        'I am good. I am updating the chat mock service.',
        sentAt: now.subtract(
          Duration(minutes: 30),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 30),
        ),
        readAt: now.subtract(
          Duration(minutes: 29),
        ),
        isMe: true,
        isRead: true,
        type: ChatMessageType.text,
        status: ChatMessageStatus.read,
        reactions: {
          '👍': 1,
        },
        myReaction: '👍',
      ),
      ChatMessageModel(
        id: 'alex_message_003',
        localId: 'local_alex_003',
        conversationId: MockIds.alexChatId,
        senderId: MockIds.alexUserId,
        senderName: 'Alex Morgan',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_002',
        text:
        'Can you send me the new design?',
        sentAt: now.subtract(
          Duration(minutes: 24),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 24),
        ),
        readAt: now.subtract(
          Duration(minutes: 23),
        ),
        isMe: false,
        isRead: true,
        type: ChatMessageType.text,
        status: ChatMessageStatus.read,
      ),
      ChatMessageModel(
        id: 'alex_message_004',
        localId: 'local_alex_004',
        conversationId: MockIds.alexChatId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text: 'Here is the updated design.',
        sentAt: now.subtract(
          Duration(minutes: 18),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 18),
        ),
        readAt: now.subtract(
          Duration(minutes: 17),
        ),
        isMe: true,
        isRead: true,
        type: ChatMessageType.image,
        status: ChatMessageStatus.read,
        mediaPath:
        'https://picsum.photos/id/48/900/700',
        thumbnailPath:
        'https://picsum.photos/id/48/300/220',
        mimeType: 'images/jpeg',
        fileSizeBytes: 248000,
        mediaWidth: 900,
        mediaHeight: 700,
        replyToMessageId:
        'alex_message_003',
        replyToText:
        'Can you send me the new design?',
        replyToSenderName: 'Alex Morgan',
        replyToType: ChatMessageType.text,
      ),
      ChatMessageModel(
        id: 'alex_message_005',
        localId: 'local_alex_005',
        conversationId: MockIds.alexChatId,
        senderId: MockIds.alexUserId,
        senderName: 'Alex Morgan',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_002',
        text: '',
        sentAt: now.subtract(
          Duration(minutes: 10),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 10),
        ),
        readAt: now.subtract(
          Duration(minutes: 9),
        ),
        isMe: false,
        isRead: true,
        type: ChatMessageType.voice,
        status: ChatMessageStatus.read,
        mediaPath:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        mimeType: 'audio/mpeg',
        durationSeconds: 18,
        waveform: [
          0.20,
          0.45,
          0.72,
          0.34,
          0.86,
          0.53,
          0.28,
          0.64,
          0.40,
        ],
      ),
      ChatMessageModel(
        id: 'alex_message_006',
        localId: 'local_alex_006',
        conversationId: MockIds.alexChatId,
        senderId: MockIds.currentUserId,
        senderName: 'Vuthul Vun',
        senderAvatar:
        'https://i.pravatar.cc/300?u=user_001',
        text: '',
        sentAt: now.subtract(
          Duration(minutes: 3),
        ),
        deliveredAt: now.subtract(
          Duration(minutes: 3),
        ),
        isMe: true,
        isRead: false,
        type: ChatMessageType.location,
        status: ChatMessageStatus.delivered,
        latitude: 11.5564,
        longitude: 104.9282,
        locationName: 'Phnom Penh',
        locationAddress:
        'Phnom Penh, Cambodia',
      ),
    ];
  }
}