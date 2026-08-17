enum ChatFolderType {
  all,
  personal,
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

  factory ChatFolderModel.fromJson(Map<String, dynamic> json) {
    ChatFolderType parseType(dynamic typeStr) {
      if (typeStr == 'all') return ChatFolderType.all;
      if (typeStr == 'personal') return ChatFolderType.personal;
      return ChatFolderType.custom;
    }

    return ChatFolderModel(
      id: json['id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: parseType(json['type']),
      chatCount: int.tryParse(json['chatCount']?.toString() ?? '0') ?? 0,
      isSystem: json['isSystem'] == 1 || json['isSystem'] == true || json['isSystem'] == '1',
      chatIds: json['chatIds'] is List ? (json['chatIds'] as List).map((e) => e.toString()).toList() : [],
    );
  }

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