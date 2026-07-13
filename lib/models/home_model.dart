class ChatModel {
  final String name;
  final String message;
  final String time;
  final String image;
  final int unread;
  final String type;

  const ChatModel({
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    this.unread = 0,
    this.type = 'personal',
  });
}