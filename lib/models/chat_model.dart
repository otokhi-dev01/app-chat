enum MessageStatus {
  sent,
  delivered,
  read,
  failed,
}

class ChatModel {
  final String id;

  /// Used for personal conversations.
  final String? peerUserId;

  /// Users participating in this conversation.
  final List<String> memberIds;

  /// ID of the latest message.
  final String? lastMessageId;

  final String name;
  final String message;
  final DateTime dateTime;
  final String image;
  final int unread;

  /// personal, group, work, saved
  final String type;

  final bool isPinned;
  final bool isMuted;
  final bool isOnline;
  final bool isTyping;
  final bool isMe;
  final bool isArchived;

  final MessageStatus status;

  /// Information from the latest message.
  final String? mediaPath;
  final double? latitude;
  final double? longitude;

  ChatModel({
    required this.id,
    this.peerUserId,
    List<String>? memberIds,
    this.lastMessageId,
    required this.name,
    required this.message,
    required this.dateTime,
    required this.type,
    this.image = 'https://i.pravatar.cc/150',
    this.unread = 0,
    this.isPinned = false,
    this.isMuted = false,
    this.isOnline = false,
    this.isTyping = false,
    this.isMe = false,
    this.isArchived = false,
    this.status = MessageStatus.sent,
    this.mediaPath,
    this.latitude,
    this.longitude,
  }) : memberIds = List<String>.unmodifiable(
    memberIds ?? <String>[],
  );

  bool get hasUnread {
    return unread > 0;
  }

  bool get isPersonal {
    return type == 'personal';
  }

  bool get isGroup {
    return type == 'group';
  }

  bool get isWork {
    return type == 'work';
  }

  bool get isSavedMessages {
    return type == 'saved';
  }

  bool get hasMedia {
    return mediaPath != null &&
        mediaPath!.trim().isNotEmpty;
  }

  bool get hasLocation {
    return latitude != null &&
        longitude != null;
  }

  String get time {
    DateTime now = DateTime.now();
    DateTime localDate = dateTime.toLocal();

    DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    DateTime messageDate = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    int difference =
        today.difference(messageDate).inDays;

    if (difference <= 0) {
      int hour = localDate.hour % 12;

      if (hour == 0) {
        hour = 12;
      }

      String period =
      localDate.hour >= 12 ? 'PM' : 'AM';

      String minute = localDate.minute
          .toString()
          .padLeft(2, '0');

      return '$hour:$minute $period';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    if (difference < 7) {
      List<String> weekdays = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];

      return weekdays[localDate.weekday - 1];
    }

    return '${localDate.day}/${localDate.month}/${localDate.year}';
  }

  ChatModel copyWith({
    String? id,
    String? peerUserId,
    List<String>? memberIds,
    String? lastMessageId,
    String? name,
    String? message,
    DateTime? dateTime,
    String? image,
    int? unread,
    String? type,
    bool? isPinned,
    bool? isMuted,
    bool? isOnline,
    bool? isTyping,
    bool? isMe,
    bool? isArchived,
    MessageStatus? status,
    String? mediaPath,
    double? latitude,
    double? longitude,
    bool clearPeerUserId = false,
    bool clearLastMessageId = false,
    bool clearMediaPath = false,
    bool clearLocation = false,
  }) {
    return ChatModel(
      id: id ?? this.id,
      peerUserId: clearPeerUserId
          ? null
          : peerUserId ?? this.peerUserId,
      memberIds: memberIds ?? this.memberIds,
      lastMessageId: clearLastMessageId
          ? null
          : lastMessageId ??
          this.lastMessageId,
      name: name ?? this.name,
      message: message ?? this.message,
      dateTime: dateTime ?? this.dateTime,
      image: image ?? this.image,
      unread: unread ?? this.unread,
      type: type ?? this.type,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      isOnline: isOnline ?? this.isOnline,
      isTyping: isTyping ?? this.isTyping,
      isMe: isMe ?? this.isMe,
      isArchived:
      isArchived ?? this.isArchived,
      status: status ?? this.status,
      mediaPath: clearMediaPath
          ? null
          : mediaPath ?? this.mediaPath,
      latitude: clearLocation
          ? null
          : latitude ?? this.latitude,
      longitude: clearLocation
          ? null
          : longitude ?? this.longitude,
    );
  }

  factory ChatModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatModel(
      id: json['id']?.toString() ?? '',
      peerUserId:
      json['peerUserId']?.toString(),
      memberIds: _parseStringList(
        json['memberIds'],
      ),
      lastMessageId:
      json['lastMessageId']?.toString(),
      name: json['name']?.toString() ?? '',
      message:
      json['message']?.toString() ?? '',
      dateTime: _parseDateTime(
        json['dateTime'],
      ),
      image: json['images']?.toString() ??
          'https://i.pravatar.cc/150',
      unread: _parseInt(json['unread']),
      type:
      json['type']?.toString() ?? 'personal',
      isPinned: _parseBool(
        json['isPinned'],
      ),
      isMuted: _parseBool(
        json['isMuted'],
      ),
      isOnline: _parseBool(
        json['isOnline'],
      ),
      isTyping: _parseBool(
        json['isTyping'],
      ),
      isMe: _parseBool(
        json['isMe'],
      ),
      isArchived: _parseBool(
        json['isArchived'],
      ),
      status: _parseMessageStatus(
        json['status']?.toString(),
      ),
      mediaPath:
      json['mediaPath']?.toString(),
      latitude: _parseDouble(
        json['latitude'],
      ),
      longitude: _parseDouble(
        json['longitude'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peerUserId': peerUserId,
      'memberIds': memberIds,
      'lastMessageId': lastMessageId,
      'name': name,
      'message': message,
      'dateTime': dateTime.toIso8601String(),
      'images': image,
      'unread': unread,
      'type': type,
      'isPinned': isPinned,
      'isMuted': isMuted,
      'isOnline': isOnline,
      'isTyping': isTyping,
      'isMe': isMe,
      'isArchived': isArchived,
      'status': status.name,
      'mediaPath': mediaPath,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static DateTime _parseDateTime(
      dynamic value,
      ) {
    return DateTime.tryParse(
      value?.toString() ?? '',
    ) ??
        DateTime.now();
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double? _parseDouble(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
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

  static List<String> _parseStringList(
      dynamic value,
      ) {
    if (value is! List) {
      return <String>[];
    }

    return value
        .map(
          (dynamic item) =>
          item.toString(),
    )
        .toList();
  }

  static MessageStatus _parseMessageStatus(
      String? value,
      ) {
    return MessageStatus.values.firstWhere(
          (MessageStatus status) {
        return status.name == value;
      },
      orElse: () {
        return MessageStatus.sent;
      },
    );
  }
}