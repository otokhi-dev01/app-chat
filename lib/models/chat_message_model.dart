enum ChatMessageType {
  text,
  image,
  voice,
  file,
}

class ChatMessageModel {
  final String id;
  final String text;
  final DateTime sentAt;
  final bool isMe;
  final bool isRead;
  final ChatMessageType type;
  final String? mediaPath;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isMe,
    this.isRead = false,
    this.type = ChatMessageType.text,
    this.mediaPath,
  });

  ChatMessageModel copyWith({
    String? id,
    String? text,
    DateTime? sentAt,
    bool? isMe,
    bool? isRead,
    ChatMessageType? type,
    String? mediaPath,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      isMe: isMe ?? this.isMe,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      mediaPath: mediaPath ?? this.mediaPath,
    );
  }
}