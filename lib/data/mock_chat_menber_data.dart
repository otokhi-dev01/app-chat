import 'mock_ids.dart';

class MockChatMemberData {
  static Map<String, List<String>> build() {
    return {
      MockIds.savedChatId: [
        MockIds.currentUserId,
      ],
      MockIds.alexChatId: [
        MockIds.currentUserId,
        MockIds.alexUserId,
      ],
      MockIds.appChatGroupId: [
        MockIds.currentUserId,
        MockIds.alexUserId,
        MockIds.amandaUserId,
        MockIds.chloeUserId,
      ],
      MockIds.officeChatId: [
        MockIds.currentUserId,
        MockIds.brianUserId,
        MockIds.danielUserId,
      ],
    };
  }
}