import 'package:flutter/cupertino.dart';

import '../../../models/chat_message_model.dart';

class ChatMessageSearchUtils {
  ChatMessageSearchUtils._();

  static String getSearchableText(ChatMessageModel message) {
    List<String> values = [
      message.text,
      getMessageTypeLabel(message),
      getFileName(message),
    ];

    if (message.latitude != null && message.longitude != null) {
      values.add('${message.latitude}, ${message.longitude}');
    }

    return values.join(' ');
  }

  static String getMessageTypeLabel(ChatMessageModel message) {
    switch (message.type) {
      case ChatMessageType.text:
        return 'text message';
      case ChatMessageType.image:
        return 'photo image picture';
      case ChatMessageType.voice:
        return 'voice audio message recording';
      case ChatMessageType.file:
        return 'file document pdf attachment';
      case ChatMessageType.location:
        return 'location map address gps';
      case ChatMessageType.video:
        return 'video movie clip';
      case ChatMessageType.contact:
        return 'contact card phone number';
      case ChatMessageType.sticker:
        return 'sticker emoji';
      case ChatMessageType.gif:
        return 'gif animation';
      case ChatMessageType.call:
        return 'call log phone video';
      case ChatMessageType.system:
        return 'system notification';
    }
  }

  static String getMessagePreview(ChatMessageModel message) {
    String text = message.text.trim();

    switch (message.type) {
      case ChatMessageType.text:
        return text.isEmpty ? 'Text message' : text;
      case ChatMessageType.image:
        return text.isEmpty ? 'Photo' : text;
      case ChatMessageType.voice:
        return text.isEmpty ? 'Voice message' : text;
      case ChatMessageType.file:
        if (text.isNotEmpty) return text;
        String fileName = getFileName(message);
        return fileName.isEmpty ? 'File' : fileName;
      case ChatMessageType.location:
        if (text.isNotEmpty) return text;
        if (message.latitude != null && message.longitude != null) {
          return '${message.latitude!.toStringAsFixed(4)}, ${message.longitude!.toStringAsFixed(4)}';
        }
        return 'Shared location';
      case ChatMessageType.video:
        return text.isEmpty ? 'Video' : text;
      case ChatMessageType.contact:
        return text.isEmpty ? 'Contact' : text;
      case ChatMessageType.sticker:
        return 'Sticker';
      case ChatMessageType.gif:
        return 'GIF';
      case ChatMessageType.call:
        return text.isEmpty ? 'Call' : text;
      case ChatMessageType.system:
        return text.isEmpty ? 'System message' : text;
    }
  }

  static String getFileName(ChatMessageModel message) {
    String? mediaPath = message.mediaPath;

    if (mediaPath == null || mediaPath.trim().isEmpty) {
      return '';
    }

    String normalizedPath = mediaPath.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  static IconData getMessageIcon(ChatMessageType type) {
    switch (type) {
      case ChatMessageType.text:
        return CupertinoIcons.chat_bubble;
      case ChatMessageType.image:
        return CupertinoIcons.photo;
      case ChatMessageType.voice:
        return CupertinoIcons.mic;
      case ChatMessageType.file:
        return CupertinoIcons.doc;
      case ChatMessageType.location:
        return CupertinoIcons.location;
      case ChatMessageType.video:
        return CupertinoIcons.videocam;
      case ChatMessageType.contact:
        return CupertinoIcons.person_crop_circle;
      case ChatMessageType.sticker:
        return CupertinoIcons.smiley;
      case ChatMessageType.gif:
        return CupertinoIcons.play_rectangle;
      case ChatMessageType.call:
        return CupertinoIcons.phone;
      case ChatMessageType.system:
        return CupertinoIcons.info_circle;
    }
  }

  static String formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    int formattedHour = hour % 12;

    if (formattedHour == 0) {
      formattedHour = 12;
    }

    String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  static String formatDate(DateTime dateTime) {
    DateTime now = DateTime.now();

    bool isToday = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      return formatTime(dateTime);
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    bool isYesterday = yesterday.year == dateTime.year &&
        yesterday.month == dateTime.month &&
        yesterday.day == dateTime.day;

    if (isYesterday) {
      return 'Yesterday';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}