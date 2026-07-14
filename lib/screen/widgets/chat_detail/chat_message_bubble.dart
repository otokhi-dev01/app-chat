import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback? onLongPress;

  ChatMessageBubble({
    super.key,
    required this.message,
    this.onLongPress,
  });

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    String period = hour >= 12 ? 'PM' : 'AM';

    int formattedHour = hour % 12;

    if (formattedHour == 0) {
      formattedHour = 12;
    }

    String formattedMinute =
    minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    bool isImageMessage =
        message.type == ChatMessageType.image &&
            message.mediaPath != null &&
            message.mediaPath!.isNotEmpty;

    Color receivedBackground = isDark
        ? Color(0xFF24272D)
        : Colors.white;

    Color receivedTextColor = isDark
        ? Colors.white
        : Color(0xFF202124);

    return Align(
      alignment: message.isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
            MediaQuery.sizeOf(context).width * 0.78,
          ),
          margin: EdgeInsets.only(
            left: message.isMe ? 55 : 12,
            right: message.isMe ? 12 : 55,
            bottom: 7,
          ),
          padding: isImageMessage
              ? EdgeInsets.all(4)
              : EdgeInsets.fromLTRB(13, 9, 10, 7),
          decoration: BoxDecoration(
            color: message.isMe
                ? AppTheme.primaryColor
                : receivedBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(
                message.isMe ? 18 : 4,
              ),
              bottomRight: Radius.circular(
                message.isMe ? 4 : 18,
              ),
            ),
            border: message.isMe
                ? null
                : Border.all(
              color: isDark
                  ? Colors.white.withValues(
                alpha: 0.05,
              )
                  : Colors.black.withValues(
                alpha: 0.05,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.12 : 0.04,
                ),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: isImageMessage
              ? _buildImageMessage(context)
              : _buildTextMessage(
            receivedTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTextMessage(
      Color receivedTextColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isMe
                  ? Colors.white
                  : receivedTextColor,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 4),
        _buildTimeStatus(),
      ],
    );
  }

  Widget _buildImageMessage(
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            _openFullImage(context);
          },
          child: Hero(
            tag: message.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(message.mediaPath!),
                width: 240,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                    ) {
                  return Container(
                    width: 240,
                    height: 180,
                    alignment: Alignment.center,
                    color: Colors.grey.shade300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade700,
                          size: 42,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image unavailable',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (message.text.trim().isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(
              8,
              8,
              8,
              2,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            top: 5,
            right: 5,
            bottom: 3,
          ),
          child: _buildTimeStatus(),
        ),
      ],
    );
  }

  Widget _buildTimeStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.sentAt),
          style: TextStyle(
            color: message.isMe
                ? Colors.white.withValues(alpha: 0.75)
                : Colors.grey,
            fontSize: 9,
            height: 1,
          ),
        ),
        if (message.isMe) ...[
          SizedBox(width: 3),
          Icon(
            message.isRead
                ? Icons.done_all_rounded
                : Icons.done_rounded,
            size: 14,
            color: message.isRead
                ? Color(0xFFB9F6CA)
                : Colors.white.withValues(alpha: 0.75),
          ),
        ],
      ],
    );
  }

  void _openFullImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              title: Text('Photo'),
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5,
                child: Hero(
                  tag: message.id,
                  child: Image.file(
                    File(message.mediaPath!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}