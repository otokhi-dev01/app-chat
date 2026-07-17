import 'chat_message_model.dart';

class SavedMessageModel {
  final ChatMessageModel data;

  SavedMessageModel({
    required String id,
    required String text,
    required DateTime dateTime,
    String conversationId =
    'conversation_saved',
    String senderId = '',
    ChatMessageType type =
        ChatMessageType.text,
    ChatMessageStatus status =
        ChatMessageStatus.read,
    bool isRead = true,
    String? mediaPath,
  }) : data = ChatMessageModel(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    text: text,
    sentAt: dateTime,
    isMe: true,
    isRead: isRead,
    type: type,
    status: status,
    mediaPath: mediaPath,
  );

  SavedMessageModel.fromMessage(
      ChatMessageModel message,
      ) : data = message;

  String get id {
    return data.id;
  }

  String get text {
    return data.text;
  }

  DateTime get dateTime {
    return data.sentAt;
  }

  String get conversationId {
    return data.conversationId;
  }

  String get senderId {
    return data.senderId;
  }

  ChatMessageType get type {
    return data.type;
  }

  ChatMessageStatus get status {
    return data.status;
  }

  bool get isRead {
    return data.isRead;
  }

  String? get mediaPath {
    return data.mediaPath;
  }

  ChatMessageModel toChatMessage() {
    return data;
  }

  SavedMessageModel copyWith({
    String? id,
    String? text,
    DateTime? dateTime,
    String? conversationId,
    String? senderId,
    ChatMessageType? type,
    ChatMessageStatus? status,
    bool? isRead,
    String? mediaPath,
  }) {
    return SavedMessageModel.fromMessage(
      data.copyWith(
        id: id,
        text: text,
        sentAt: dateTime,
        conversationId: conversationId,
        senderId: senderId,
        type: type,
        status: status,
        isRead: isRead,
        mediaPath: mediaPath,
      ),
    );
  }

  factory SavedMessageModel.fromJson(
      Map<String, dynamic> json,
      ) {
    Map<String, dynamic> normalized =
    Map<String, dynamic>.from(json);

    normalized['sentAt'] =
        json['sentAt'] ??
            json['dateTime'] ??
            DateTime.now().toIso8601String();

    normalized['conversationId'] =
        json['conversationId'] ??
            'conversation_saved';

    normalized['senderId'] =
        json['senderId'] ?? '';

    normalized['isMe'] = true;

    return SavedMessageModel.fromMessage(
      ChatMessageModel.fromJson(
        normalized,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json =
    data.toJson();

    json['dateTime'] =
        data.sentAt.toIso8601String();

    return json;
  }
}