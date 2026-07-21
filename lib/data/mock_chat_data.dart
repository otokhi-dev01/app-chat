import '../../models/chat_model.dart';
import 'mock_ids.dart';

class MockChatData {
  static List<ChatModel> build() {
    DateTime now = DateTime.now();

    return [
      ChatModel(
        id: MockIds.savedChatId,
        name: 'Saved Messages',
        message:
        'Review WebSocket reconnection flow.',
        dateTime: now.subtract(
          Duration(minutes: 12),
        ),
        image: '',
        unread: 0,
        type: 'saved',
        isPinned: true,
        isMuted: false,
        isOnline: false,
        isTyping: false,
        isMe: true,
        isArchived: false,
        status: MessageStatus.read,
      ),
      ChatModel(
        id: MockIds.alexChatId,
        name: 'Alex Morgan',
        message: 'Phnom Penh',
        dateTime: now.subtract(
          Duration(minutes: 3),
        ),
        image:
        'https://i.pravatar.cc/300?u=user_002',
        unread: 0,
        type: 'personal',
        isPinned: true,
        isMuted: false,
        isOnline: true,
        isTyping: false,
        isMe: true,
        isArchived: false,
        status: MessageStatus.delivered,
        latitude: 11.5564,
        longitude: 104.9282,
      ),
      ChatModel(
        id: MockIds.appChatGroupId,
        name: 'AppChat Development',
        message:
        'Amanda: I pushed the API update.',
        dateTime: now.subtract(
          Duration(minutes: 8),
        ),
        image:
        'https://picsum.photos/id/20/300',
        unread: 5,
        type: 'group',
        isPinned: false,
        isMuted: false,
        isOnline: false,
        isTyping: true,
        isMe: false,
        isArchived: false,
        status: MessageStatus.delivered,
      ),
      ChatModel(
        id: MockIds.officeChatId,
        name: 'Office Team',
        message:
        'The meeting starts at 3:00 PM.',
        dateTime: now.subtract(
          Duration(hours: 1),
        ),
        image:
        'https://picsum.photos/id/48/300',
        unread: 1,
        type: 'work',
        isPinned: false,
        isMuted: true,
        isOnline: false,
        isTyping: false,
        isMe: false,
        isArchived: true,
        status: MessageStatus.delivered,
      ),
    ];
  }
}