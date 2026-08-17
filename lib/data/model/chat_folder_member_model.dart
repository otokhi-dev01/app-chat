class ChatFolderMemberModel {
  final String id;
  final String username;
  final String name;
  final String phoneNumber;
  final String email;
  final String avatarUrl;
  final bool isOnline;

  const ChatFolderMemberModel({
    required this.id,
    required this.username,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.avatarUrl,
    required this.isOnline,
  });

  factory ChatFolderMemberModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatFolderMemberModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber:
      json['phoneNumber']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      isOnline: _parseBool(json['isOnline']),
    );
  }

  String get displayUsername {
    if (username.isEmpty || username.startsWith('@')) {
      return username;
    }

    return '@$username';
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    return value == 1 ||
        value == '1' ||
        value?.toString().toLowerCase() == 'true';
  }
}