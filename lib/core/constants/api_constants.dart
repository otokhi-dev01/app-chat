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

  static Uri uri(String endpoint) {
    return Uri.parse('$baseUrl$endpoint');
  }
}