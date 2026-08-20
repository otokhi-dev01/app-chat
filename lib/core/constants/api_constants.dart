class ApiConstants {
  static const String baseUrl =
      'http://192.168.100.50:8000/api';

  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendEmailOtp = '/auth/email/send-otp';
  static const String verifyEmailOtp = '/auth/email/verify-otp';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/me';
  // Users
  static const String users = '/users';
  static String userById(String userId) {return '$users/$userId';}
  static String userPresence(String userId) {return '$users/$userId/presence';}
  static String searchUsers({required String search, int page = 1, int perPage = 20,}) {return Uri(path: users, queryParameters: {'search': search, 'page': page.toString(), 'per_page': perPage.toString(),},).toString();}
  // Chat folders
  static const String chatFolders = '/chat-folders';
  static const String chatFolderMemberOptions ='/chat-folders/member-options';
  static String chatFolderById(String folderId) {return '$chatFolders/$folderId';}
  static String chatFolderMembers({String search = '',}) {return Uri(path: chatFolderMemberOptions, queryParameters: search.trim().isEmpty ? null : {'search': search.trim(),},).toString();}
  // Contacts
  static const String contacts = '/contacts';
  static const String contactUserOptions = '/contacts/user-options';
  static String contactById(String contactId) {return '$contacts/$contactId';}
  static String contactList({String search = '',}) {return Uri(path: contacts, queryParameters: search.trim().isEmpty ? null : {'search': search.trim(),},).toString();}
  static String searchContactUsers({required String search,}) {return Uri(path: contactUserOptions, queryParameters: {'search': search.trim(),},).toString();}

  // Phone Contacts
  static const String phoneContacts = '/phone-contacts';
  static String phoneContactById(String contactId) {return '$phoneContacts/$contactId';}

  // Device sessions
  static const String deviceSessions ='/device-sessions';
  static const String currentDeviceHeartbeat ='/device-sessions/current';
  static const String otherDeviceSessions ='/device-sessions/others';
  static String deviceSessionById(String sessionId,) {return '$deviceSessions/$sessionId';}
  
  // Chat
  static const String groupChats = '/chats/groups';
  static const String chats = '/chats';
  static String chatById(String chatId) => '$chats/$chatId';
  static String chatPreferences(String chatId) => '$chats/$chatId/preferences';
  static String chatMarkRead(String chatId) => '$chats/$chatId/read';
  static String chatMessages(String chatId) => '$chats/$chatId/messages';
  static String chatMessageById(String chatId, String messageId) => '$chats/$chatId/messages/$messageId';

  static Uri uri(String endpoint) {
    return Uri.parse('$baseUrl$endpoint');
  }
}