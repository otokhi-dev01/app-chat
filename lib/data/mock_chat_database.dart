// import '../models/chat_message_model.dart';
// import '../models/chat_model.dart';
// import '../models/contact_model.dart';
// import '../models/save_message_model.dart';
// import '../models/user_model.dart';
//
// class MockChatDatabase {
//   static String currentUserId = 'user_001';
//
//   static String savedChatId =
//       'chat_saved_user_001';
//
//   // ============================================================
//   // USERS AND PROFILES
//   // ============================================================
//
//   static List<AppUserModel> users = [
//     AppUserModel(
//       id: 'user_001',
//       username: 'vuthul',
//       name: 'Vuthul Vun',
//       phoneNumber: '+855 12 345 678',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_001',
//       bio: 'Flutter developer',
//       isOnline: true,
//       lastSeenAt: DateTime.now(),
//     ),
//     AppUserModel(
//       id: 'user_002',
//       username: 'alex_morgan',
//       name: 'Alex Morgan',
//       phoneNumber: '+855 96 222 1111',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_002',
//       bio: 'Mobile UI designer',
//       isOnline: true,
//       lastSeenAt: DateTime.now(),
//     ),
//     AppUserModel(
//       id: 'user_003',
//       username: 'amanda_lee',
//       name: 'Amanda Lee',
//       phoneNumber: '+855 10 444 222',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_003',
//       bio: 'Backend developer',
//       isOnline: false,
//       lastSeenAt: DateTime.now().subtract(
//         Duration(minutes: 25),
//       ),
//     ),
//     AppUserModel(
//       id: 'user_004',
//       username: 'brian_cooper',
//       name: 'Brian Cooper',
//       phoneNumber: '+855 70 555 333',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_004',
//       bio: 'Project manager',
//       isOnline: false,
//       lastSeenAt: DateTime.now().subtract(
//         Duration(hours: 3),
//       ),
//     ),
//     AppUserModel(
//       id: 'user_005',
//       username: 'chloe_bennett',
//       name: 'Chloe Bennett',
//       phoneNumber: '+855 12 555 001',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_005',
//       bio: 'Product designer',
//       isOnline: true,
//       lastSeenAt: DateTime.now(),
//     ),
//     AppUserModel(
//       id: 'user_006',
//       username: 'daniel_kim',
//       name: 'Daniel Kim',
//       phoneNumber: '+855 15 555 002',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_006',
//       bio: 'Mobile developer',
//       isOnline: false,
//       lastSeenAt: DateTime.now().subtract(
//         Duration(hours: 7),
//       ),
//     ),
//   ];
//
//   // AppUserModel already contains profile information:
//   // name, username, phoneNumber, avatarUrl and bio.
//
//   static AppUserModel? get currentProfile {
//     return findUserById(currentUserId);
//   }
//
//   // ============================================================
//   // CONTACTS
//   // ============================================================
//
//   // ContactModel.id is the same as AppUserModel.id.
//   //
//   // Example:
//   // ContactModel.id = user_002
//   // AppUserModel.id = user_002
//
//   static List<ContactModel> contacts = [
//     ContactModel(
//       id: 'user_002',
//       name: 'Alex Morgan',
//       username: '@alex_morgan',
//       phoneNumber: '+855 96 222 1111',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_002',
//       status: ContactStatus.online,
//       isFavorite: true,
//       isBlocked: false,
//     ),
//     ContactModel(
//       id: 'user_003',
//       name: 'Amanda Lee',
//       username: '@amanda_lee',
//       phoneNumber: '+855 10 444 222',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_003',
//       status: ContactStatus.recently,
//       isFavorite: false,
//       isBlocked: false,
//     ),
//     ContactModel(
//       id: 'user_004',
//       name: 'Brian Cooper',
//       username: '@brian_cooper',
//       phoneNumber: '+855 70 555 333',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_004',
//       status: ContactStatus.offline,
//       isFavorite: false,
//       isBlocked: false,
//     ),
//     ContactModel(
//       id: 'user_005',
//       name: 'Chloe Bennett',
//       username: '@chloe_bennett',
//       phoneNumber: '+855 12 555 001',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_005',
//       status: ContactStatus.online,
//       isFavorite: true,
//       isBlocked: false,
//     ),
//     ContactModel(
//       id: 'user_006',
//       name: 'Daniel Kim',
//       username: '@daniel_kim',
//       phoneNumber: '+855 15 555 002',
//       avatarUrl:
//       'https://i.pravatar.cc/300?u=user_006',
//       status: ContactStatus.offline,
//       isFavorite: false,
//       isBlocked: false,
//     ),
//   ];
//
//   // ============================================================
//   // CHAT MEMBERS
//   // ============================================================
//
//   // ChatModel currently does not contain member IDs.
//   // Keep relationships in this map.
//   //
//   // Personal chat:
//   // current user + one other user
//   //
//   // Group chat:
//   // current user + many other users
//   //
//   // Saved Messages:
//   // current user only
//
//   static Map<String, List<String>> chatMemberIds = {
//     'chat_saved_user_001': [
//       'user_001',
//     ],
//     'chat_personal_alex': [
//       'user_001',
//       'user_002',
//     ],
//     'chat_group_appchat': [
//       'user_001',
//       'user_002',
//       'user_003',
//       'user_005',
//     ],
//     'chat_work_office': [
//       'user_001',
//       'user_004',
//       'user_006',
//     ],
//   };
//
//   // ============================================================
//   // CHAT LIST
//   // ============================================================
//
//   static List<ChatModel> chats = [
//     ChatModel(
//       id: 'chat_saved_user_001',
//       name: 'Saved Messages',
//       message: 'Review WebSocket reconnection flow.',
//       dateTime: DateTime.now().subtract(
//         Duration(minutes: 12),
//       ),
//       image: '',
//       unread: 0,
//       type: 'saved',
//       isPinned: true,
//       isMuted: false,
//       isOnline: false,
//       isTyping: false,
//       isMe: true,
//       isArchived: false,
//       status: MessageStatus.read,
//     ),
//     ChatModel(
//       id: 'chat_personal_alex',
//       name: 'Alex Morgan',
//       message: 'Phnom Penh',
//       dateTime: DateTime.now().subtract(
//         Duration(minutes: 3),
//       ),
//       image:
//       'https://i.pravatar.cc/300?u=user_002',
//       unread: 0,
//       type: 'personal',
//       isPinned: true,
//       isMuted: false,
//       isOnline: true,
//       isTyping: false,
//       isMe: true,
//       isArchived: false,
//       status: MessageStatus.delivered,
//       latitude: 11.5564,
//       longitude: 104.9282,
//     ),
//     ChatModel(
//       id: 'chat_group_appchat',
//       name: 'AppChat Development',
//       message: 'Amanda: I pushed the API update.',
//       dateTime: DateTime.now().subtract(
//         Duration(minutes: 8),
//       ),
//       image:
//       'https://picsum.photos/id/20/300',
//       unread: 5,
//       type: 'group',
//       isPinned: false,
//       isMuted: false,
//       isOnline: false,
//       isTyping: true,
//       isMe: false,
//       isArchived: false,
//       status: MessageStatus.delivered,
//     ),
//     ChatModel(
//       id: 'chat_work_office',
//       name: 'Office Team',
//       message: 'The meeting starts at 3:00 PM.',
//       dateTime: DateTime.now().subtract(
//         Duration(hours: 1),
//       ),
//       image:
//       'https://picsum.photos/id/48/300',
//       unread: 1,
//       type: 'work',
//       isPinned: false,
//       isMuted: true,
//       isOnline: false,
//       isTyping: false,
//       isMe: false,
//       isArchived: false,
//       status: MessageStatus.delivered,
//     ),
//   ];
//
//   // ============================================================
//   // MESSAGES
//   // ============================================================
//
//   static Map<String, List<ChatMessageModel>>
//   messages = {
//     // ----------------------------------------------------------
//     // SAVED MESSAGES
//     // ----------------------------------------------------------
//
//     'chat_saved_user_001': [
//       ChatMessageModel(
//         id: 'saved_message_001',
//         localId: 'local_saved_001',
//         conversationId:
//         'chat_saved_user_001',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text:
//         'Remember to update the notification service.',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 35),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 35),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 35),
//         ),
//         isMe: true,
//         isRead: true,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.read,
//       ),
//       ChatMessageModel(
//         id: 'saved_message_002',
//         localId: 'local_saved_002',
//         conversationId:
//         'chat_saved_user_001',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text: '',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 20),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 20),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 20),
//         ),
//         isMe: true,
//         isRead: true,
//         type: ChatMessageType.file,
//         status: ChatMessageStatus.read,
//         mediaPath:
//         'https://example.com/files/chat-schema.pdf',
//         fileName: 'chat-schema.pdf',
//         mimeType: 'application/pdf',
//         fileSizeBytes: 340000,
//       ),
//       ChatMessageModel(
//         id: 'saved_message_003',
//         localId: 'local_saved_003',
//         conversationId:
//         'chat_saved_user_001',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text:
//         'Review WebSocket reconnection flow.',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 12),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 12),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 12),
//         ),
//         isMe: true,
//         isRead: true,
//         isPinned: true,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.read,
//       ),
//     ],
//
//     // ----------------------------------------------------------
//     // PERSONAL CHAT
//     // ----------------------------------------------------------
//
//     'chat_personal_alex': [
//       ChatMessageModel(
//         id: 'alex_message_001',
//         localId: 'local_alex_001',
//         conversationId:
//         'chat_personal_alex',
//         senderId: 'user_002',
//         senderName: 'Alex Morgan',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_002',
//         text: 'Hello Vuthul, how are you?',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 35),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 35),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 34),
//         ),
//         isMe: false,
//         isRead: true,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.read,
//       ),
//       ChatMessageModel(
//         id: 'alex_message_002',
//         localId: 'local_alex_002',
//         conversationId:
//         'chat_personal_alex',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text:
//         'I am good. I am updating the chat mock service.',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 30),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 30),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 29),
//         ),
//         isMe: true,
//         isRead: true,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.read,
//         reactions: {
//           '👍': 1,
//         },
//         myReaction: '👍',
//       ),
//       ChatMessageModel(
//         id: 'alex_message_003',
//         localId: 'local_alex_003',
//         conversationId:
//         'chat_personal_alex',
//         senderId: 'user_002',
//         senderName: 'Alex Morgan',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_002',
//         text: 'Can you send me the new design?',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 24),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 24),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 23),
//         ),
//         isMe: false,
//         isRead: true,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.read,
//       ),
//       ChatMessageModel(
//         id: 'alex_message_004',
//         localId: 'local_alex_004',
//         conversationId:
//         'chat_personal_alex',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text: 'Here is the updated design.',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 18),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 18),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 17),
//         ),
//         isMe: true,
//         isRead: true,
//         type: ChatMessageType.image,
//         status: ChatMessageStatus.read,
//         mediaPath:
//         'https://picsum.photos/id/48/900/700',
//         thumbnailPath:
//         'https://picsum.photos/id/48/300/220',
//         mimeType: 'image/jpeg',
//         fileSizeBytes: 248000,
//         mediaWidth: 900,
//         mediaHeight: 700,
//         replyToMessageId:
//         'alex_message_003',
//         replyToText:
//         'Can you send me the new design?',
//         replyToSenderName: 'Alex Morgan',
//         replyToType: ChatMessageType.text,
//       ),
//       ChatMessageModel(
//         id: 'alex_message_005',
//         localId: 'local_alex_005',
//         conversationId:
//         'chat_personal_alex',
//         senderId: 'user_002',
//         senderName: 'Alex Morgan',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_002',
//         text: '',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 10),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 10),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(minutes: 9),
//         ),
//         isMe: false,
//         isRead: true,
//         type: ChatMessageType.voice,
//         status: ChatMessageStatus.read,
//         mediaPath:
//         'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//         mimeType: 'audio/mpeg',
//         durationSeconds: 18,
//         waveform: [
//           0.20,
//           0.45,
//           0.72,
//           0.34,
//           0.86,
//           0.53,
//           0.28,
//           0.64,
//           0.40,
//         ],
//       ),
//       ChatMessageModel(
//         id: 'alex_message_006',
//         localId: 'local_alex_006',
//         conversationId:
//         'chat_personal_alex',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text: '',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 3),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 3),
//         ),
//         isMe: true,
//         isRead: false,
//         type: ChatMessageType.location,
//         status: ChatMessageStatus.delivered,
//         latitude: 11.5564,
//         longitude: 104.9282,
//         locationName: 'Phnom Penh',
//         locationAddress:
//         'Phnom Penh, Cambodia',
//       ),
//     ],
//
//     // ----------------------------------------------------------
//     // GROUP CHAT
//     // ----------------------------------------------------------
//
//     'chat_group_appchat': [
//       ChatMessageModel(
//         id: 'group_message_001',
//         localId: 'local_group_001',
//         conversationId:
//         'chat_group_appchat',
//         senderId: 'system',
//         senderName: 'AppChat',
//         senderAvatar: '',
//         text:
//         'Alex Morgan created the group.',
//         sentAt: DateTime.now().subtract(
//           Duration(hours: 3),
//         ),
//         isMe: false,
//         isRead: true,
//         type: ChatMessageType.system,
//         status: ChatMessageStatus.read,
//       ),
//       ChatMessageModel(
//         id: 'group_message_002',
//         localId: 'local_group_002',
//         conversationId:
//         'chat_group_appchat',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text: 'Good morning team.',
//         sentAt: DateTime.now().subtract(
//           Duration(hours: 2),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(hours: 2),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(hours: 1, minutes: 58),
//         ),
//         isMe: true,
//         isRead: true,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.read,
//         reactions: {
//           '👍': 3,
//           '❤️': 1,
//         },
//         myReaction: '👍',
//       ),
//       ChatMessageModel(
//         id: 'group_message_003',
//         localId: 'local_group_003',
//         conversationId:
//         'chat_group_appchat',
//         senderId: 'user_005',
//         senderName: 'Chloe Bennett',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_005',
//         text: '',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 50),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 50),
//         ),
//         isMe: false,
//         isRead: false,
//         type: ChatMessageType.contact,
//         status: ChatMessageStatus.delivered,
//         contactName: 'Daniel Kim',
//         contactPhoneNumber:
//         '+855 15 555 002',
//         contactUserId: 'user_006',
//       ),
//       ChatMessageModel(
//         id: 'group_message_004',
//         localId: 'local_group_004',
//         conversationId:
//         'chat_group_appchat',
//         senderId: 'user_003',
//         senderName: 'Amanda Lee',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_003',
//         text: 'I pushed the API update.',
//         sentAt: DateTime.now().subtract(
//           Duration(minutes: 8),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(minutes: 8),
//         ),
//         isMe: false,
//         isRead: false,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.delivered,
//         reactions: {
//           '🔥': 2,
//         },
//       ),
//     ],
//
//     // ----------------------------------------------------------
//     // WORK CHAT
//     // ----------------------------------------------------------
//
//     'chat_work_office': [
//       ChatMessageModel(
//         id: 'work_message_001',
//         localId: 'local_work_001',
//         conversationId:
//         'chat_work_office',
//         senderId: 'user_001',
//         senderName: 'Vuthul Vun',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_001',
//         text: 'What time is the meeting?',
//         sentAt: DateTime.now().subtract(
//           Duration(hours: 1, minutes: 20),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(hours: 1, minutes: 20),
//         ),
//         readAt: DateTime.now().subtract(
//           Duration(hours: 1, minutes: 18),
//         ),
//         isMe: true,
//         isRead: true,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.read,
//       ),
//       ChatMessageModel(
//         id: 'work_message_002',
//         localId: 'local_work_002',
//         conversationId:
//         'chat_work_office',
//         senderId: 'user_004',
//         senderName: 'Brian Cooper',
//         senderAvatar:
//         'https://i.pravatar.cc/300?u=user_004',
//         text:
//         'The meeting starts at 3:00 PM.',
//         sentAt: DateTime.now().subtract(
//           Duration(hours: 1),
//         ),
//         deliveredAt: DateTime.now().subtract(
//           Duration(hours: 1),
//         ),
//         isMe: false,
//         isRead: false,
//         type: ChatMessageType.text,
//         status: ChatMessageStatus.delivered,
//       ),
//     ],
//   };
//
//   // ============================================================
//   // SAVED MESSAGE MODEL
//   // ============================================================
//
//   // SavedMessageModel is generated from the special saved chat.
//   // This prevents duplicated saved-message data.
//
//   static List<SavedMessageModel>
//   get savedMessages {
//     List<ChatMessageModel> source =
//         messages[savedChatId] ??
//             <ChatMessageModel>[];
//
//     return source.map(
//           (ChatMessageModel message) {
//         return SavedMessageModel(
//           id: message.id,
//           text: message.displayText,
//           dateTime: message.sentAt,
//         );
//       },
//     ).toList();
//   }
//
//   // ============================================================
//   // USER HELPERS
//   // ============================================================
//
//   static AppUserModel? findUserById(
//       String userId,
//       ) {
//     int index = users.indexWhere(
//           (AppUserModel user) {
//         return user.id == userId;
//       },
//     );
//
//     if (index < 0) {
//       return null;
//     }
//
//     return users[index];
//   }
//
//   static AppUserModel? findUserByUsername(
//       String username,
//       ) {
//     String cleanUsername = username
//         .trim()
//         .replaceFirst('@', '')
//         .toLowerCase();
//
//     int index = users.indexWhere(
//           (AppUserModel user) {
//         return user.username
//             .trim()
//             .replaceFirst('@', '')
//             .toLowerCase() ==
//             cleanUsername;
//       },
//     );
//
//     if (index < 0) {
//       return null;
//     }
//
//     return users[index];
//   }
//
//   static List<AppUserModel> searchUsers(
//       String query,
//       ) {
//     String cleanQuery =
//     query.trim().toLowerCase();
//
//     if (cleanQuery.isEmpty) {
//       return <AppUserModel>[];
//     }
//
//     return users.where(
//           (AppUserModel user) {
//         return user.name
//             .toLowerCase()
//             .contains(cleanQuery) ||
//             user.username
//                 .toLowerCase()
//                 .contains(cleanQuery) ||
//             user.phoneNumber
//                 .toLowerCase()
//                 .contains(cleanQuery);
//       },
//     ).toList();
//   }
//
//   // ============================================================
//   // CONTACT HELPERS
//   // ============================================================
//
//   static ContactModel? findContactById(
//       String contactId,
//       ) {
//     int index = contacts.indexWhere(
//           (ContactModel contact) {
//         return contact.id == contactId;
//       },
//     );
//
//     if (index < 0) {
//       return null;
//     }
//
//     return contacts[index];
//   }
//
//   static AppUserModel? getContactUser(
//       ContactModel contact,
//       ) {
//     return findUserById(contact.id);
//   }
//
//   static bool contactExists(
//       String userId,
//       ) {
//     return contacts.any(
//           (ContactModel contact) {
//         return contact.id == userId;
//       },
//     );
//   }
//
//   static ContactModel? addUserToContacts(
//       String userId,
//       ) {
//     if (contactExists(userId)) {
//       return findContactById(userId);
//     }
//
//     AppUserModel? user =
//     findUserById(userId);
//
//     if (user == null ||
//         user.id == currentUserId) {
//       return null;
//     }
//
//     ContactModel contact = ContactModel(
//       id: user.id,
//       name: user.name,
//       username: user.username.startsWith('@')
//           ? user.username
//           : '@${user.username}',
//       phoneNumber: user.phoneNumber,
//       avatarUrl: user.avatarUrl,
//       status: user.isOnline
//           ? ContactStatus.online
//           : ContactStatus.offline,
//       isFavorite: false,
//       isBlocked: false,
//     );
//
//     contacts.add(contact);
//
//     contacts.sort(
//           (
//           ContactModel first,
//           ContactModel second,
//           ) {
//         return first.name
//             .toLowerCase()
//             .compareTo(
//           second.name.toLowerCase(),
//         );
//       },
//     );
//
//     return contact;
//   }
//
//   static void removeContact(
//       String userId,
//       ) {
//     contacts.removeWhere(
//           (ContactModel contact) {
//         return contact.id == userId;
//       },
//     );
//   }
//
//   // ============================================================
//   // CHAT HELPERS
//   // ============================================================
//
//   static ChatModel? findChatById(
//       String chatId,
//       ) {
//     int index = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (index < 0) {
//       return null;
//     }
//
//     return chats[index];
//   }
//
//   static List<String> getChatMemberIds(
//       String chatId,
//       ) {
//     return chatMemberIds[chatId]?.toList() ??
//         <String>[];
//   }
//
//   static List<AppUserModel> getChatMembers(
//       String chatId,
//       ) {
//     List<String> memberIds =
//     getChatMemberIds(chatId);
//
//     return memberIds
//         .map(findUserById)
//         .whereType<AppUserModel>()
//         .toList();
//   }
//
//   static AppUserModel?
//   getPersonalChatOtherUser(
//       String chatId,
//       ) {
//     List<String> members =
//     getChatMemberIds(chatId);
//
//     for (String memberId in members) {
//       if (memberId != currentUserId) {
//         return findUserById(memberId);
//       }
//     }
//
//     return null;
//   }
//
//   static List<ChatModel> get activeChats {
//     List<ChatModel> result = chats.where(
//           (ChatModel chat) {
//         return !chat.isArchived;
//       },
//     ).toList();
//
//     result.sort(
//           (
//           ChatModel first,
//           ChatModel second,
//           ) {
//         if (first.isPinned != second.isPinned) {
//           return first.isPinned ? -1 : 1;
//         }
//
//         return second.dateTime.compareTo(
//           first.dateTime,
//         );
//       },
//     );
//
//     return result;
//   }
//
//   static List<ChatModel> get archivedChats {
//     return chats.where(
//           (ChatModel chat) {
//         return chat.isArchived;
//       },
//     ).toList();
//   }
//
//   static void markChatRead(
//       String chatId,
//       ) {
//     int index = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (index < 0) {
//       return;
//     }
//
//     chats[index] = chats[index].copyWith(
//       unread: 0,
//     );
//   }
//
//   static void toggleChatPinned(
//       String chatId,
//       ) {
//     int index = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (index < 0) {
//       return;
//     }
//
//     ChatModel chat = chats[index];
//
//     chats[index] = chat.copyWith(
//       isPinned: !chat.isPinned,
//     );
//   }
//
//   static void toggleChatMuted(
//       String chatId,
//       ) {
//     int index = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (index < 0) {
//       return;
//     }
//
//     ChatModel chat = chats[index];
//
//     chats[index] = chat.copyWith(
//       isMuted: !chat.isMuted,
//     );
//   }
//
//   static void archiveChat(
//       String chatId,
//       ) {
//     int index = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (index < 0) {
//       return;
//     }
//
//     chats[index] = chats[index].copyWith(
//       isArchived: true,
//     );
//   }
//
//   static void unarchiveChat(
//       String chatId,
//       ) {
//     int index = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (index < 0) {
//       return;
//     }
//
//     chats[index] = chats[index].copyWith(
//       isArchived: false,
//     );
//   }
//
//   // ============================================================
//   // MESSAGE HELPERS
//   // ============================================================
//
//   static List<ChatMessageModel> getMessages(
//       String chatId,
//       ) {
//     List<ChatMessageModel> result =
//         messages[chatId]?.toList() ??
//             <ChatMessageModel>[];
//
//     result.sort(
//           (
//           ChatMessageModel first,
//           ChatMessageModel second,
//           ) {
//         return first.sentAt.compareTo(
//           second.sentAt,
//         );
//       },
//     );
//
//     return result;
//   }
//
//   static ChatMessageModel? findMessageById({
//     required String chatId,
//     required String messageId,
//   }) {
//     List<ChatMessageModel> chatMessages =
//         messages[chatId] ??
//             <ChatMessageModel>[];
//
//     int index = chatMessages.indexWhere(
//           (ChatMessageModel message) {
//         return message.id == messageId;
//       },
//     );
//
//     if (index < 0) {
//       return null;
//     }
//
//     return chatMessages[index];
//   }
//
//   static ChatMessageModel sendTextMessage({
//     required String chatId,
//     required String text,
//   }) {
//     String cleanText = text.trim();
//
//     if (cleanText.isEmpty) {
//       throw ArgumentError(
//         'Message text cannot be empty.',
//       );
//     }
//
//     AppUserModel? currentUser =
//     findUserById(currentUserId);
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
//       senderId: currentUserId,
//       senderName:
//       currentUser?.name ?? 'Current user',
//       senderAvatar:
//       currentUser?.avatarUrl ?? '',
//       text: cleanText,
//       sentAt: DateTime.now(),
//       isMe: true,
//       isRead: false,
//       type: ChatMessageType.text,
//       status: ChatMessageStatus.sent,
//     );
//
//     addMessage(
//       chatId: chatId,
//       message: message,
//     );
//
//     return message;
//   }
//
//   static void addMessage({
//     required String chatId,
//     required ChatMessageModel message,
//   }) {
//     messages.putIfAbsent(
//       chatId,
//           () {
//         return <ChatMessageModel>[];
//       },
//     );
//
//     messages[chatId]!.add(message);
//
//     _updateChatFromMessage(
//       chatId: chatId,
//       message: message,
//     );
//   }
//
//   static void deleteMessage({
//     required String chatId,
//     required String messageId,
//   }) {
//     List<ChatMessageModel>? chatMessages =
//     messages[chatId];
//
//     if (chatMessages == null) {
//       return;
//     }
//
//     chatMessages.removeWhere(
//           (ChatMessageModel message) {
//         return message.id == messageId;
//       },
//     );
//
//     _updateChatFromLastMessage(chatId);
//   }
//
//   static void markMessageRead({
//     required String chatId,
//     required String messageId,
//   }) {
//     List<ChatMessageModel>? chatMessages =
//     messages[chatId];
//
//     if (chatMessages == null) {
//       return;
//     }
//
//     int index = chatMessages.indexWhere(
//           (ChatMessageModel message) {
//         return message.id == messageId;
//       },
//     );
//
//     if (index < 0) {
//       return;
//     }
//
//     chatMessages[index] =
//         chatMessages[index].copyWith(
//           isRead: true,
//           status: ChatMessageStatus.read,
//           readAt: DateTime.now(),
//         );
//
//     _updateChatFromLastMessage(chatId);
//   }
//
//   static void _updateChatFromLastMessage(
//       String chatId,
//       ) {
//     List<ChatMessageModel> chatMessages =
//     getMessages(chatId);
//
//     if (chatMessages.isEmpty) {
//       _clearChatLastMessage(chatId);
//       return;
//     }
//
//     _updateChatFromMessage(
//       chatId: chatId,
//       message: chatMessages.last,
//     );
//   }
//
//   static void _clearChatLastMessage(
//       String chatId,
//       ) {
//     int chatIndex = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (chatIndex < 0) {
//       return;
//     }
//
//     ChatModel oldChat = chats[chatIndex];
//
//     chats[chatIndex] = ChatModel(
//       id: oldChat.id,
//       name: oldChat.name,
//       message: '',
//       dateTime: oldChat.dateTime,
//       image: oldChat.image,
//       unread: 0,
//       type: oldChat.type,
//       isPinned: oldChat.isPinned,
//       isMuted: oldChat.isMuted,
//       isOnline: oldChat.isOnline,
//       isTyping: oldChat.isTyping,
//       isMe: false,
//       isArchived: oldChat.isArchived,
//       status: MessageStatus.sent,
//     );
//   }
//
//   static void _updateChatFromMessage({
//     required String chatId,
//     required ChatMessageModel message,
//   }) {
//     int chatIndex = chats.indexWhere(
//           (ChatModel chat) {
//         return chat.id == chatId;
//       },
//     );
//
//     if (chatIndex < 0) {
//       return;
//     }
//
//     ChatModel oldChat = chats[chatIndex];
//
//     int unreadCount = oldChat.unread;
//
//     if (message.isMe) {
//       unreadCount = 0;
//     } else {
//       unreadCount += 1;
//     }
//
//     chats[chatIndex] = ChatModel(
//       id: oldChat.id,
//       name: oldChat.name,
//       message: message.displayText,
//       dateTime: message.sentAt,
//       image: oldChat.image,
//       unread: unreadCount,
//       type: oldChat.type,
//       isPinned: oldChat.isPinned,
//       isMuted: oldChat.isMuted,
//       isOnline: oldChat.isOnline,
//       isTyping: false,
//       isMe: message.isMe,
//       isArchived: oldChat.isArchived,
//       status: _convertMessageStatus(
//         message.status,
//       ),
//       mediaPath: message.mediaPath,
//       latitude: message.latitude,
//       longitude: message.longitude,
//     );
//   }
//
//   static MessageStatus _convertMessageStatus(
//       ChatMessageStatus status,
//       ) {
//     switch (status) {
//       case ChatMessageStatus.read:
//         return MessageStatus.read;
//
//       case ChatMessageStatus.delivered:
//         return MessageStatus.delivered;
//
//       case ChatMessageStatus.failed:
//         return MessageStatus.failed;
//
//       case ChatMessageStatus.sending:
//       case ChatMessageStatus.sent:
//         return MessageStatus.sent;
//     }
//   }
//
//   // ============================================================
//   // RESET MOCK DATA
//   // ============================================================
//
//   static void resetRuntimeChanges() {
//     // Later you can reload all data from JSON here.
//     //
//     // For now this method is intentionally empty because
//     // the mock collections are initialized directly above.
//   }
// }




import '../../models/chat_message_model.dart';
import '../../models/chat_model.dart';
import '../../models/contact_model.dart';
import '../../models/save_message_model.dart';
import '../../models/user_model.dart';
import 'mock_chat_data.dart';
import 'mock_chat_menber_data.dart';
import 'mock_contact_data.dart';
import 'mock_ids.dart';
import 'mock_message_data.dart';
import 'mock_saved_message_data.dart';
import 'mock_user_data.dart';

class MockChatDatabase {
  static String get currentUserId {
    return MockIds.currentUserId;
  }

  static String get savedChatId {
    return MockIds.savedChatId;
  }

  static List<AppUserModel> users =
  MockUserData.build();

  static List<ContactModel> contacts =
  MockContactData.build();

  static List<ChatModel> chats =
  MockChatData.build();

  static Map<String, List<String>>
  chatMemberIds =
  MockChatMemberData.build();

  static Map<String, List<ChatMessageModel>>
  messages =
  MockMessageData.build();

  static AppUserModel? get currentProfile {
    return findUserById(currentUserId);
  }

  static List<SavedMessageModel>
  get savedMessages {
    List<ChatMessageModel> saved =
        messages[savedChatId] ??
            <ChatMessageModel>[];

    return MockSavedMessageData.fromMessages(
      saved,
    );
  }

  static AppUserModel? findUserById(
      String userId,
      ) {
    int index = users.indexWhere(
          (AppUserModel user) {
        return user.id == userId;
      },
    );

    if (index < 0) {
      return null;
    }

    return users[index];
  }

  static ContactModel? findContactById(
      String userId,
      ) {
    int index = contacts.indexWhere(
          (ContactModel contact) {
        return contact.id == userId;
      },
    );

    if (index < 0) {
      return null;
    }

    return contacts[index];
  }

  static ChatModel? findChatById(
      String chatId,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return null;
    }

    return chats[index];
  }

  static List<String> getChatMemberIds(
      String chatId,
      ) {
    return chatMemberIds[chatId]?.toList() ??
        <String>[];
  }

  static List<AppUserModel> getChatMembers(
      String chatId,
      ) {
    List<String> memberIds =
    getChatMemberIds(chatId);

    return memberIds
        .map(findUserById)
        .whereType<AppUserModel>()
        .toList();
  }

  static AppUserModel?
  getPersonalChatOtherUser(
      String chatId,
      ) {
    List<String> members =
    getChatMemberIds(chatId);

    for (String memberId in members) {
      if (memberId != currentUserId) {
        return findUserById(memberId);
      }
    }

    return null;
  }

  static List<ChatModel> get activeChats {
    List<ChatModel> result = chats.where(
          (ChatModel chat) {
        return !chat.isArchived;
      },
    ).toList();

    result.sort(
          (
          ChatModel first,
          ChatModel second,
          ) {
        if (first.isPinned != second.isPinned) {
          return first.isPinned ? -1 : 1;
        }

        return second.dateTime.compareTo(
          first.dateTime,
        );
      },
    );

    return result;
  }

  static List<ChatModel> get archivedChats {
    return chats.where(
          (ChatModel chat) {
        return chat.isArchived;
      },
    ).toList();
  }

  static List<ChatMessageModel> getMessages(
      String chatId,
      ) {
    List<ChatMessageModel> result =
        messages[chatId]?.toList() ??
            <ChatMessageModel>[];

    result.sort(
          (
          ChatMessageModel first,
          ChatMessageModel second,
          ) {
        return first.sentAt.compareTo(
          second.sentAt,
        );
      },
    );

    return result;
  }

  static void addMessage({
    required String chatId,
    required ChatMessageModel message,
  }) {
    messages.putIfAbsent(
      chatId,
          () {
        return <ChatMessageModel>[];
      },
    );

    messages[chatId]!.add(message);

    _updateChatFromMessage(
      chatId: chatId,
      message: message,
    );
  }

  static void deleteMessage({
    required String chatId,
    required String messageId,
  }) {
    List<ChatMessageModel>? chatMessages =
    messages[chatId];

    if (chatMessages == null) {
      return;
    }

    chatMessages.removeWhere(
          (ChatMessageModel message) {
        return message.id == messageId;
      },
    );

    _updateChatFromLastMessage(chatId);
  }

  static void markChatRead(
      String chatId,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return;
    }

    chats[index] = chats[index].copyWith(
      unread: 0,
    );
  }

  static void archiveChat(
      String chatId,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return;
    }

    chats[index] = chats[index].copyWith(
      isArchived: true,
    );
  }

  static void unarchiveChat(
      String chatId,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return;
    }

    chats[index] = chats[index].copyWith(
      isArchived: false,
    );
  }

  static void reset() {
    users = MockUserData.build();

    contacts = MockContactData.build();

    chats = MockChatData.build();

    chatMemberIds =
        MockChatMemberData.build();

    messages = MockMessageData.build();
  }

  static void _updateChatFromLastMessage(
      String chatId,
      ) {
    List<ChatMessageModel> chatMessages =
    getMessages(chatId);

    if (chatMessages.isEmpty) {
      _clearChatLastMessage(chatId);
      return;
    }

    _updateChatFromMessage(
      chatId: chatId,
      message: chatMessages.last,
    );
  }

  static void _clearChatLastMessage(
      String chatId,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return;
    }

    ChatModel oldChat = chats[index];

    chats[index] = ChatModel(
      id: oldChat.id,
      name: oldChat.name,
      message: '',
      dateTime: oldChat.dateTime,
      image: oldChat.image,
      unread: 0,
      type: oldChat.type,
      isPinned: oldChat.isPinned,
      isMuted: oldChat.isMuted,
      isOnline: oldChat.isOnline,
      isTyping: oldChat.isTyping,
      isMe: false,
      isArchived: oldChat.isArchived,
      status: MessageStatus.sent,
    );
  }

  static void _updateChatFromMessage({
    required String chatId,
    required ChatMessageModel message,
  }) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return;
    }

    ChatModel oldChat = chats[index];

    int unread = message.isMe
        ? 0
        : oldChat.unread + 1;

    chats[index] = ChatModel(
      id: oldChat.id,
      name: oldChat.name,
      message: message.displayText,
      dateTime: message.sentAt,
      image: oldChat.image,
      unread: unread,
      type: oldChat.type,
      isPinned: oldChat.isPinned,
      isMuted: oldChat.isMuted,
      isOnline: oldChat.isOnline,
      isTyping: false,
      isMe: message.isMe,
      isArchived: oldChat.isArchived,
      status: _convertStatus(
        message.status,
      ),
      mediaPath: message.mediaPath,
      latitude: message.latitude,
      longitude: message.longitude,
    );
  }

  static MessageStatus _convertStatus(
      ChatMessageStatus status,
      ) {
    switch (status) {
      case ChatMessageStatus.read:
        return MessageStatus.read;

      case ChatMessageStatus.delivered:
        return MessageStatus.delivered;

      case ChatMessageStatus.failed:
        return MessageStatus.failed;

      case ChatMessageStatus.sending:
      case ChatMessageStatus.sent:
        return MessageStatus.sent;
    }
  }
}