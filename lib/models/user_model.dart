class AppUserModel {
  final String id;
  final String username;
  final String name;
  final String phoneNumber;
  final String email;
  final String avatarUrl;
  final String bio;
  final bool isOnline;
  final DateTime? lastSeenAt;

  AppUserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.phoneNumber,
    this.email = '',
    required this.avatarUrl,
    required this.bio,
    required this.isOnline,
    this.lastSeenAt,
  });

  bool get hasAvatar {
    return avatarUrl.trim().isNotEmpty;
  }

  bool get hasPhoneNumber {
    return phoneNumber.trim().isNotEmpty;
  }

  String get displayUsername {
    String cleanUsername = username.trim();

    if (cleanUsername.isEmpty) {
      return '';
    }

    if (cleanUsername.startsWith('@')) {
      return cleanUsername;
    }

    return '@$cleanUsername';
  }

  String get statusText {
    if (isOnline) {
      return 'Online';
    }

    if (lastSeenAt == null) {
      return 'Offline';
    }

    return 'Last seen ${lastSeenAt!.toLocal()}';
  }

  AppUserModel copyWith({
    String? id,
    String? username,
    String? name,
    String? phoneNumber,
    String? email,
    String? avatarUrl,
    String? bio,
    bool? isOnline,
    DateTime? lastSeenAt,
    bool clearLastSeenAt = false,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      phoneNumber:
      phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: clearLastSeenAt
          ? null
          : lastSeenAt ?? this.lastSeenAt,
    );
  }

  factory AppUserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AppUserModel(
      id: json['id']?.toString() ?? '',
      username:
      json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber:
      json['phoneNumber']?.toString() ??
          json['phone_number']?.toString() ??
          '',
      email: json['email']?.toString() ?? '',
      avatarUrl:
      json['avatarUrl']?.toString() ??
          json['avatar_url']?.toString() ??
          '',
      bio: json['bio']?.toString() ?? '',
      isOnline: _parseBool(
        json['isOnline'] ?? json['is_online'],
      ),
      lastSeenAt: _parseDateTime(
        json['lastSeenAt'] ??
            json['last_seen_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'isOnline': isOnline,
      'lastSeenAt':
      lastSeenAt?.toIso8601String(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    String text =
        value?.toString().toLowerCase() ?? '';

    return text == 'true' || text == '1';
  }

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }
}