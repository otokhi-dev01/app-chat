enum ChatMessageType {
  text,
  image,
  voice,
  file,
  location,
}

class ChatMessageModel {
  final String id;
  final String text;
  final DateTime sentAt;
  final bool isMe;
  final bool isRead;
  final ChatMessageType type;
  final String? mediaPath;
  final double? latitude;
  final double? longitude;
  final int? durationSeconds;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isMe,
    this.isRead = false,
    this.type = ChatMessageType.text,
    this.mediaPath,
    this.latitude,
    this.longitude,
    this.durationSeconds,
  });

  ChatMessageModel copyWith({
    String? id,
    String? text,
    DateTime? sentAt,
    bool? isMe,
    bool? isRead,
    ChatMessageType? type,
    String? mediaPath,
    double? latitude,
    double? longitude,
    int? durationSeconds,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      isMe: isMe ?? this.isMe,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      mediaPath: mediaPath ?? this.mediaPath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      durationSeconds:
      durationSeconds ?? this.durationSeconds,
    );
  }
}