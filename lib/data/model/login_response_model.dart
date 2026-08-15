/// Response returned by POST /auth/login/verify-otp (step 2 — the real,
/// final login response), and also by GET /auth/me and the refresh
/// endpoint, since they all share the same { accessToken, data } shape
/// on the backend (see AuthenticatedUserResource / issueAccessTokenResponse).
class LoginResponseModel {
  final String message;
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final LoginDataModel? data;

  const LoginResponseModel({
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];

    return LoginResponseModel(
      message: json['message']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
      data: rawData is Map
          ? LoginDataModel.fromJson(Map<String, dynamic>.from(rawData))
          : null,
    );
  }
}

/// Mirrors AuthenticatedUserResource on the Laravel side exactly:
/// id, username, name, phoneNumber, email, avatarUrl, bio, isOnline,
/// lastSeenAt.
class LoginDataModel {
  final String id;
  final String username;
  final String name;
  final String phoneNumber;
  final String email;
  final String avatarUrl;
  final String bio;
  final bool isOnline;
  final DateTime? lastSeenAt;

  const LoginDataModel({
    required this.id,
    required this.username,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.isOnline,
    required this.lastSeenAt,
  });

  /// Used in AppFeedback messages ("Welcome back, ...").
  /// Falls back to the username if the display name is blank.
  String get fullName => name.trim().isNotEmpty ? name.trim() : '@$username';

  /// Alias kept for existing call sites (e.g. ProfileController) that
  /// reference `.phone` instead of `.phoneNumber`.
  String get phone => phoneNumber;

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    final String? lastSeenRaw = json['lastSeenAt']?.toString();

    return LoginDataModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      isOnline: json['isOnline'] == true,
      lastSeenAt: (lastSeenRaw == null || lastSeenRaw.isEmpty)
          ? null
          : DateTime.tryParse(lastSeenRaw),
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
      'lastSeenAt': lastSeenAt?.toIso8601String(),
    };
  }
}