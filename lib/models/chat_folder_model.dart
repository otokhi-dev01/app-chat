enum ChatFolderType {
  all,
  unread,
  personal,
  groups,
  custom,
}

class ChatFolderModel {
  final String id;
  final String name;
  final ChatFolderType type;
  final int chatCount;
  final bool isSystem;
  final List<String> chatIds;

  ChatFolderModel({
    required this.id,
    required this.name,
    required this.type,
    required this.chatCount,
    required this.isSystem,
    List<String>? chatIds,
  }) : chatIds = List<String>.unmodifiable(
    chatIds ?? <String>[],
  );

  ChatFolderModel copyWith({
    String? id,
    String? name,
    ChatFolderType? type,
    int? chatCount,
    bool? isSystem,
    List<String>? chatIds,
  }) {
    return ChatFolderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      chatCount: chatCount ?? this.chatCount,
      isSystem: isSystem ?? this.isSystem,
      chatIds: chatIds ?? this.chatIds,
    );
  }
}