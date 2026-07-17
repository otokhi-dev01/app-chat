enum ChatMessageType {
  text,
  image,
  video,
  voice,
  file,
  location,
  contact,
  sticker,
  gif,
  call,
  system,
}

enum ChatMessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class ChatMessageModel {
  final String id;

  /// ID generated locally before the server returns an ID.
  final String? localId;

  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderAvatar;

  final String text;
  final DateTime sentAt;
  final DateTime? updatedAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  final bool isMe;
  final bool isRead;
  final bool isEdited;
  final bool isDeleted;
  final bool isPinned;
  final bool isForwarded;

  final ChatMessageType type;
  final ChatMessageStatus status;

  /// Image, video, voice, GIF, sticker, or file path.
  final String? mediaPath;

  /// Smaller image used before loading the full media.
  final String? thumbnailPath;

  /// File information.
  final String? fileName;
  final String? mimeType;
  final int? fileSizeBytes;

  /// Image or video dimensions.
  final int? mediaWidth;
  final int? mediaHeight;

  /// Voice or video duration.
  final int? durationSeconds;

  /// Optional voice-message waveform.
  final List<double> waveform;

  /// Location information.
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String? locationAddress;

  /// Reply information.
  final String? replyToMessageId;
  final String? replyToText;
  final String? replyToSenderName;
  final ChatMessageType? replyToType;

  /// Forwarded message information.
  final String? forwardedFromName;
  final String? forwardedFromMessageId;

  /// Contact-message information.
  final String? contactName;
  final String? contactPhoneNumber;
  final String? contactUserId;

  /// Call-message information.
  final bool? isVideoCall;
  final bool? isMissedCall;

  /// Example:
  /// {
  ///   '❤️': 2,
  ///   '👍': 5,
  /// }
  final Map<String, int> reactions;

  /// Reaction selected by the current user.
  final String? myReaction;

  /// Error when message sending fails.
  final String? errorMessage;

  /// Additional data that does not need a dedicated field yet.
  final Map<String, dynamic> metadata;

  ChatMessageModel({
    required this.id,
    this.localId,
    this.conversationId = '',
    this.senderId = '',
    this.senderName = '',
    this.senderAvatar = '',
    required this.text,
    required this.sentAt,
    required this.isMe,
    this.updatedAt,
    this.deliveredAt,
    this.readAt,
    this.isRead = false,
    this.isEdited = false,
    this.isDeleted = false,
    this.isPinned = false,
    this.isForwarded = false,
    this.type = ChatMessageType.text,
    this.status = ChatMessageStatus.sent,
    this.mediaPath,
    this.thumbnailPath,
    this.fileName,
    this.mimeType,
    this.fileSizeBytes,
    this.mediaWidth,
    this.mediaHeight,
    this.durationSeconds,
    this.waveform = const [],
    this.latitude,
    this.longitude,
    this.locationName,
    this.locationAddress,
    this.replyToMessageId,
    this.replyToText,
    this.replyToSenderName,
    this.replyToType,
    this.forwardedFromName,
    this.forwardedFromMessageId,
    this.contactName,
    this.contactPhoneNumber,
    this.contactUserId,
    this.isVideoCall,
    this.isMissedCall,
    this.reactions = const {},
    this.myReaction,
    this.errorMessage,
    this.metadata = const {},
  });

  bool get hasMedia {
    return mediaPath != null &&
        mediaPath!.trim().isNotEmpty;
  }

  bool get hasReply {
    return replyToMessageId != null &&
        replyToMessageId!.trim().isNotEmpty;
  }

  bool get hasLocation {
    return latitude != null && longitude != null;
  }

  bool get hasReactions {
    return reactions.isNotEmpty;
  }

  bool get isSending {
    return status == ChatMessageStatus.sending;
  }

  bool get isFailed {
    return status == ChatMessageStatus.failed;
  }

  bool get isDelivered {
    return status == ChatMessageStatus.delivered ||
        status == ChatMessageStatus.read;
  }

  String get displayText {
    if (isDeleted) {
      return 'This message was deleted';
    }

    if (text.trim().isNotEmpty) {
      return text;
    }

    switch (type) {
      case ChatMessageType.image:
        return 'Photo';

      case ChatMessageType.video:
        return 'Video';

      case ChatMessageType.voice:
        return 'Voice message';

      case ChatMessageType.file:
        return fileName ?? 'File';

      case ChatMessageType.location:
        return locationName ?? 'Location';

      case ChatMessageType.contact:
        return contactName ?? 'Contact';

      case ChatMessageType.sticker:
        return 'Sticker';

      case ChatMessageType.gif:
        return 'GIF';

      case ChatMessageType.call:
        if (isMissedCall == true) {
          return isVideoCall == true
              ? 'Missed video call'
              : 'Missed audio call';
        }

        return isVideoCall == true
            ? 'Video call'
            : 'Audio call';

      case ChatMessageType.system:
        return 'System message';

      case ChatMessageType.text:
        return '';
    }
  }

  String get formattedDuration {
    int totalSeconds = durationSeconds ?? 0;

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedSeconds =
    seconds.toString().padLeft(2, '0');

    return '$minutes:$formattedSeconds';
  }

  ChatMessageModel copyWith({
    String? id,
    String? localId,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? text,
    DateTime? sentAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isMe,
    bool? isRead,
    bool? isEdited,
    bool? isDeleted,
    bool? isPinned,
    bool? isForwarded,
    ChatMessageType? type,
    ChatMessageStatus? status,
    String? mediaPath,
    String? thumbnailPath,
    String? fileName,
    String? mimeType,
    int? fileSizeBytes,
    int? mediaWidth,
    int? mediaHeight,
    int? durationSeconds,
    List<double>? waveform,
    double? latitude,
    double? longitude,
    String? locationName,
    String? locationAddress,
    String? replyToMessageId,
    String? replyToText,
    String? replyToSenderName,
    ChatMessageType? replyToType,
    String? forwardedFromName,
    String? forwardedFromMessageId,
    String? contactName,
    String? contactPhoneNumber,
    String? contactUserId,
    bool? isVideoCall,
    bool? isMissedCall,
    Map<String, int>? reactions,
    String? myReaction,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      conversationId:
      conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar:
      senderAvatar ?? this.senderAvatar,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt:
      deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      isMe: isMe ?? this.isMe,
      isRead: isRead ?? this.isRead,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isPinned: isPinned ?? this.isPinned,
      isForwarded:
      isForwarded ?? this.isForwarded,
      type: type ?? this.type,
      status: status ?? this.status,
      mediaPath: mediaPath ?? this.mediaPath,
      thumbnailPath:
      thumbnailPath ?? this.thumbnailPath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSizeBytes:
      fileSizeBytes ?? this.fileSizeBytes,
      mediaWidth: mediaWidth ?? this.mediaWidth,
      mediaHeight:
      mediaHeight ?? this.mediaHeight,
      durationSeconds:
      durationSeconds ?? this.durationSeconds,
      waveform: waveform ?? this.waveform,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName:
      locationName ?? this.locationName,
      locationAddress:
      locationAddress ?? this.locationAddress,
      replyToMessageId:
      replyToMessageId ?? this.replyToMessageId,
      replyToText:
      replyToText ?? this.replyToText,
      replyToSenderName:
      replyToSenderName ?? this.replyToSenderName,
      replyToType:
      replyToType ?? this.replyToType,
      forwardedFromName:
      forwardedFromName ?? this.forwardedFromName,
      forwardedFromMessageId:
      forwardedFromMessageId ??
          this.forwardedFromMessageId,
      contactName:
      contactName ?? this.contactName,
      contactPhoneNumber:
      contactPhoneNumber ??
          this.contactPhoneNumber,
      contactUserId:
      contactUserId ?? this.contactUserId,
      isVideoCall:
      isVideoCall ?? this.isVideoCall,
      isMissedCall:
      isMissedCall ?? this.isMissedCall,
      reactions: reactions ?? this.reactions,
      myReaction: myReaction ?? this.myReaction,
      errorMessage:
      errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }

  factory ChatMessageModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      localId: json['localId']?.toString(),
      conversationId:
      json['conversationId']?.toString() ?? '',
      senderId:
      json['senderId']?.toString() ?? '',
      senderName:
      json['senderName']?.toString() ?? '',
      senderAvatar:
      json['senderAvatar']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      sentAt: DateTime.tryParse(
        json['sentAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
      updatedAt: _parseDateTime(
        json['updatedAt'],
      ),
      deliveredAt: _parseDateTime(
        json['deliveredAt'],
      ),
      readAt: _parseDateTime(
        json['readAt'],
      ),
      isMe: json['isMe'] == true,
      isRead: json['isRead'] == true,
      isEdited: json['isEdited'] == true,
      isDeleted: json['isDeleted'] == true,
      isPinned: json['isPinned'] == true,
      isForwarded:
      json['isForwarded'] == true,
      type: _parseMessageType(
        json['type']?.toString(),
      ),
      status: _parseMessageStatus(
        json['status']?.toString(),
      ),
      mediaPath:
      json['mediaPath']?.toString(),
      thumbnailPath:
      json['thumbnailPath']?.toString(),
      fileName: json['fileName']?.toString(),
      mimeType: json['mimeType']?.toString(),
      fileSizeBytes:
      _parseInt(json['fileSizeBytes']),
      mediaWidth:
      _parseInt(json['mediaWidth']),
      mediaHeight:
      _parseInt(json['mediaHeight']),
      durationSeconds:
      _parseInt(json['durationSeconds']),
      waveform: _parseDoubleList(
        json['waveform'],
      ),
      latitude: _parseDouble(
        json['latitude'],
      ),
      longitude: _parseDouble(
        json['longitude'],
      ),
      locationName:
      json['locationName']?.toString(),
      locationAddress:
      json['locationAddress']?.toString(),
      replyToMessageId:
      json['replyToMessageId']?.toString(),
      replyToText:
      json['replyToText']?.toString(),
      replyToSenderName:
      json['replyToSenderName']?.toString(),
      replyToType: json['replyToType'] == null
          ? null
          : _parseMessageType(
        json['replyToType'].toString(),
      ),
      forwardedFromName:
      json['forwardedFromName']?.toString(),
      forwardedFromMessageId:
      json['forwardedFromMessageId']
          ?.toString(),
      contactName:
      json['contactName']?.toString(),
      contactPhoneNumber:
      json['contactPhoneNumber']?.toString(),
      contactUserId:
      json['contactUserId']?.toString(),
      isVideoCall: json['isVideoCall'] as bool?,
      isMissedCall:
      json['isMissedCall'] as bool?,
      reactions: _parseReactions(
        json['reactions'],
      ),
      myReaction:
      json['myReaction']?.toString(),
      errorMessage:
      json['errorMessage']?.toString(),
      metadata: json['metadata']
      is Map<String, dynamic>
          ? Map<String, dynamic>.from(
        json['metadata'],
      )
          : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localId': localId,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      'updatedAt':
      updatedAt?.toIso8601String(),
      'deliveredAt':
      deliveredAt?.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'isMe': isMe,
      'isRead': isRead,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'isPinned': isPinned,
      'isForwarded': isForwarded,
      'type': type.name,
      'status': status.name,
      'mediaPath': mediaPath,
      'thumbnailPath': thumbnailPath,
      'fileName': fileName,
      'mimeType': mimeType,
      'fileSizeBytes': fileSizeBytes,
      'mediaWidth': mediaWidth,
      'mediaHeight': mediaHeight,
      'durationSeconds': durationSeconds,
      'waveform': waveform,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'locationAddress': locationAddress,
      'replyToMessageId': replyToMessageId,
      'replyToText': replyToText,
      'replyToSenderName':
      replyToSenderName,
      'replyToType': replyToType?.name,
      'forwardedFromName':
      forwardedFromName,
      'forwardedFromMessageId':
      forwardedFromMessageId,
      'contactName': contactName,
      'contactPhoneNumber':
      contactPhoneNumber,
      'contactUserId': contactUserId,
      'isVideoCall': isVideoCall,
      'isMissedCall': isMissedCall,
      'reactions': reactions,
      'myReaction': myReaction,
      'errorMessage': errorMessage,
      'metadata': metadata,
    };
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

  static int? _parseInt(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  static double? _parseDouble(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }

  static List<double> _parseDoubleList(
      dynamic value,
      ) {
    if (value is! List) {
      return <double>[];
    }

    return value
        .map(
          (dynamic item) {
        return _parseDouble(item);
      },
    )
        .whereType<double>()
        .toList();
  }

  static Map<String, int> _parseReactions(
      dynamic value,
      ) {
    if (value is! Map) {
      return <String, int>{};
    }

    Map<String, int> result =
    <String, int>{};

    value.forEach(
          (
          dynamic key,
          dynamic count,
          ) {
        int? parsedCount =
        _parseInt(count);

        if (parsedCount != null) {
          result[key.toString()] =
              parsedCount;
        }
      },
    );

    return result;
  }

  static ChatMessageType _parseMessageType(
      String? value,
      ) {
    return ChatMessageType.values.firstWhere(
          (ChatMessageType item) {
        return item.name == value;
      },
      orElse: () {
        return ChatMessageType.text;
      },
    );
  }

  static ChatMessageStatus
  _parseMessageStatus(
      String? value,
      ) {
    return ChatMessageStatus.values.firstWhere(
          (ChatMessageStatus item) {
        return item.name == value;
      },
      orElse: () {
        return ChatMessageStatus.sent;
      },
    );
  }
}