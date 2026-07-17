enum ContactStatus {
  online,
  recently,
  offline,
}

class ContactModel {
  final String id;

  /// Current user who saved this contact.
  final String ownerUserId;

  /// App user represented by this contact.
  final String contactUserId;

  final String name;
  final String username;
  final String phoneNumber;
  final String avatarUrl;
  final ContactStatus status;
  final bool isFavorite;
  final bool isBlocked;

  ContactModel({
    required this.id,
    this.ownerUserId = '',
    String? contactUserId,
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.status,
    this.isFavorite = false,
    this.isBlocked = false,
  }) : contactUserId = contactUserId ?? id;

  bool get isOnline {
    return status == ContactStatus.online;
  }

  bool get isRecentlyOnline {
    return status == ContactStatus.recently;
  }

  bool get isRegisteredUser {
    return contactUserId.trim().isNotEmpty;
  }

  String get firstLetter {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      return '?';
    }

    return cleanName[0].toUpperCase();
  }

  String get statusText {
    switch (status) {
      case ContactStatus.online:
        return 'Online';

      case ContactStatus.recently:
        return 'Recently';

      case ContactStatus.offline:
        return 'Offline';
    }
  }

  ContactModel copyWith({
    String? id,
    String? ownerUserId,
    String? contactUserId,
    String? name,
    String? username,
    String? phoneNumber,
    String? avatarUrl,
    ContactStatus? status,
    bool? isFavorite,
    bool? isBlocked,
  }) {
    return ContactModel(
      id: id ?? this.id,
      ownerUserId:
      ownerUserId ?? this.ownerUserId,
      contactUserId:
      contactUserId ?? this.contactUserId,
      name: name ?? this.name,
      username: username ?? this.username,
      phoneNumber:
      phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      isFavorite:
      isFavorite ?? this.isFavorite,
      isBlocked:
      isBlocked ?? this.isBlocked,
    );
  }

  factory ContactModel.fromJson(
      Map<String, dynamic> json,
      ) {
    String id =
        json['id']?.toString() ?? '';

    return ContactModel(
      id: id,
      ownerUserId:
      json['ownerUserId']?.toString() ??
          '',
      contactUserId:
      json['contactUserId']?.toString() ??
          id,
      name: json['name']?.toString() ?? '',
      username:
      json['username']?.toString() ?? '',
      phoneNumber:
      json['phoneNumber']?.toString() ??
          '',
      avatarUrl:
      json['avatarUrl']?.toString() ?? '',
      status: _parseContactStatus(
        json['status']?.toString(),
      ),
      isFavorite: _parseBool(
        json['isFavorite'],
      ),
      isBlocked: _parseBool(
        json['isBlocked'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerUserId': ownerUserId,
      'contactUserId': contactUserId,
      'name': name,
      'username': username,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'status': status.name,
      'isFavorite': isFavorite,
      'isBlocked': isBlocked,
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

  static ContactStatus _parseContactStatus(
      String? value,
      ) {
    return ContactStatus.values.firstWhere(
          (ContactStatus status) {
        return status.name == value;
      },
      orElse: () {
        return ContactStatus.offline;
      },
    );
  }
}