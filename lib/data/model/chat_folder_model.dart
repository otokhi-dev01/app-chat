class ChatFolderModel {
  final String id;
  final String name;
  final String type;
  final int chatCount;
  final bool isSystem;
  final List<String> chatIds;

  const ChatFolderModel({
    required this.id,
    required this.name,
    required this.type,
    required this.chatCount,
    required this.isSystem,
    required this.chatIds,
  });

  factory ChatFolderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatFolderModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'custom',
      chatCount: _parseInt(json['chatCount']),
      isSystem: _parseBool(json['isSystem']),
      chatIds: _parseStringList(json['chatIds']),
    );
  }

  ChatFolderModel copyWith({
    String? id,
    String? name,
    String? type,
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

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    return value == 1 ||
        value == '1' ||
        value?.toString().toLowerCase() == 'true';
  }

  static List<String> _parseStringList(
      dynamic value,
      ) {
    if (value is! List) {
      return [];
    }

    return value
        .map((item) => item.toString())
        .toList(growable: false);
  }
}