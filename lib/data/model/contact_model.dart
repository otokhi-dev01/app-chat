class ContactModel {
  final String id;
  final String ownerUserId;
  final String contactUserId;
  final String name;
  final String username;
  final String phoneNumber;
  final String avatarUrl;
  final String status;
  final bool isFavorite;
  final bool isBlocked;

  const ContactModel({
    required this.id,
    required this.ownerUserId,
    required this.contactUserId,
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.status,
    required this.isFavorite,
    required this.isBlocked,
  });

  factory ContactModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ContactModel(
      id: json['id']?.toString() ?? '',
      ownerUserId:
      json['ownerUserId']?.toString() ?? '',
      contactUserId:
      json['contactUserId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      phoneNumber:
      json['phoneNumber']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      status: json['status']?.toString() ?? 'offline',
      isFavorite: _parseBool(json['isFavorite']),
      isBlocked: _parseBool(json['isBlocked']),
    );
  }

  ContactModel copyWith({
    String? name,
    String? status,
    bool? isFavorite,
    bool? isBlocked,
  }) {
    return ContactModel(
      id: id,
      ownerUserId: ownerUserId,
      contactUserId: contactUserId,
      name: name ?? this.name,
      username: username,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  String get displayUsername {
    if (username.isEmpty || username.startsWith('@')) {
      return username;
    }

    return '@$username';
  }

  bool get isOnline => status == 'online';

  bool get wasRecentlyOnline => status == 'recently';

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    return value == 1 ||
        value == '1' ||
        value?.toString().toLowerCase() == 'true';
  }
}