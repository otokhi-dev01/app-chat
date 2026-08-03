class BlockedContactModel {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;

  const BlockedContactModel({
    required this.id,
    required this.name,
    required this.username,
    this.avatarUrl = '',
  });
}