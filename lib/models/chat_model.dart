import 'package:flutter/material.dart';

enum MessageStatus { sent, delivered, read }

class ChatModel {
  final String id;
  final String name;
  final String message;
  final DateTime dateTime;
  final String image;
  final int unread;
  final String type; // 'personal' or 'group'
  final bool isPinned;
  final bool isMuted;
  final bool isOnline;
  final bool isTyping;
  final bool isMe; // true if last message was sent by current user
  final MessageStatus status;

  const ChatModel({
    required this.id,
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
    this.status = MessageStatus.sent,
  });

  bool get hasUnread => unread > 0;

  // chat_title.dart expects `chat.time` as a formatted String.
  String get time {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(dateTime);

    if (diff.inDays == 0 && now.day == dateTime.day) {
      final int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final String period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final String minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    }

    if (diff.inDays == 1 || (diff.inDays == 0 && now.day != dateTime.day)) {
      return 'Yesterday';
    }

    if (diff.inDays < 7) {
      const List<String> weekdays = [
        'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
      ];
      return weekdays[dateTime.weekday - 1];
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  ChatModel copyWith({
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
    MessageStatus? status,
  }) {
    return ChatModel(
      id: id,
      name: name,
      message: message ?? this.message,
      dateTime: dateTime ?? this.dateTime,
      image: image ?? this.image,
      type: type ?? this.type,
      unread: unread ?? this.unread,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      isOnline: isOnline ?? this.isOnline,
      isTyping: isTyping ?? this.isTyping,
      isMe: isMe ?? this.isMe,
      status: status ?? this.status,
    );
  }
}