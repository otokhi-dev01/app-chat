//
// import '../data/mock_chat_database.dart';
// import '../models/chat_message_model.dart';
// import '../models/chat_model.dart';
// import '../models/contact_model.dart';
// import '../models/save_message_model.dart';
// import '../models/user_model.dart';
// import 'chat_data_service.dart';
//
// class MockChatService
//     implements ChatDataService {
//   Future<void> _simulateDelay() async {
//     await Future<void>.delayed(
//       Duration(milliseconds: 300),
//     );
//   }
//
//   @override
//   Future<AppUserModel?>
//   getCurrentProfile() async {
//     await _simulateDelay();
//
//     return MockChatDatabase.currentProfile;
//   }
//
//   @override
//   Future<List<AppUserModel>>
//   getUsers() async {
//     await _simulateDelay();
//
//     return MockChatDatabase.users.toList();
//   }
//
//   @override
//   Future<List<ContactModel>>
//   getContacts() async {
//     await _simulateDelay();
//
//     return MockChatDatabase.contacts.toList();
//   }
//
//   @override
//   Future<List<ChatModel>> getChats() async {
//     await _simulateDelay();
//
//     return MockChatDatabase.activeChats;
//   }
//
//   @override
//   Future<List<ChatModel>>
//   getArchivedChats() async {
//     await _simulateDelay();
//
//     return MockChatDatabase.archivedChats;
//   }
//
//   @override
//   Future<List<ChatMessageModel>> getMessages(
//       String chatId,
//       ) async {
//     await _simulateDelay();
//
//     return MockChatDatabase.getMessages(
//       chatId,
//     );
//   }
//
//   @override
//   Future<List<SavedMessageModel>>
//   getSavedMessages() async {
//     await _simulateDelay();
//
//     return MockChatDatabase.savedMessages;
//   }
//
//   @override
//   Future<List<AppUserModel>> getChatMembers(
//       String chatId,
//       ) async {
//     await _simulateDelay();
//
//     return MockChatDatabase.getChatMembers(
//       chatId,
//     );
//   }
//
//   @override
//   Future<ChatMessageModel> sendTextMessage({
//     required String chatId,
//     required String text,
//   }) async {
//     String cleanText = text.trim();
//
//     if (cleanText.isEmpty) {
//       throw ArgumentError(
//         'Message cannot be empty.',
//       );
//     }
//
//     AppUserModel? currentUser =
//         MockChatDatabase.currentProfile;
//
//     String timestamp = DateTime.now()
//         .microsecondsSinceEpoch
//         .toString();
//
//     ChatMessageModel message =
//     ChatMessageModel(
//       id: 'message_$timestamp',
//       localId: 'local_$timestamp',
//       conversationId: chatId,
//       senderId:
//       MockChatDatabase.currentUserId,
//       senderName:
//       currentUser?.name ?? 'Current user',
//       senderAvatar:
//       currentUser?.avatarUrl ?? '',
//       text: cleanText,
//       sentAt: DateTime.now(),
//       isMe: true,
//       isRead: false,
//       type: ChatMessageType.text,
//       status: ChatMessageStatus.sending,
//     );
//
//     MockChatDatabase.addMessage(
//       chatId: chatId,
//       message: message,
//     );
//
//     await _simulateDelay();
//
//     ChatMessageModel sentMessage =
//     message.copyWith(
//       status: ChatMessageStatus.sent,
//     );
//
//     List<ChatMessageModel>? chatMessages =
//     MockChatDatabase.messages[chatId];
//
//     if (chatMessages != null) {
//       int index = chatMessages.indexWhere(
//             (ChatMessageModel item) {
//           return item.id == message.id;
//         },
//       );
//
//       if (index >= 0) {
//         chatMessages[index] = sentMessage;
//       }
//     }
//
//     return sentMessage;
//   }
//
//   @override
//   Future<void> deleteMessage({
//     required String chatId,
//     required String messageId,
//   }) async {
//     await _simulateDelay();
//
//     MockChatDatabase.deleteMessage(
//       chatId: chatId,
//       messageId: messageId,
//     );
//   }
//
//   @override
//   Future<void> markChatRead(
//       String chatId,
//       ) async {
//     await _simulateDelay();
//
//     MockChatDatabase.markChatRead(chatId);
//   }
//
//   @override
//   Future<void> archiveChat(
//       String chatId,
//       ) async {
//     await _simulateDelay();
//
//     MockChatDatabase.archiveChat(chatId);
//   }
//
//   @override
//   Future<void> unarchiveChat(
//       String chatId,
//       ) async {
//     await _simulateDelay();
//
//     MockChatDatabase.unarchiveChat(chatId);
//   }
// }