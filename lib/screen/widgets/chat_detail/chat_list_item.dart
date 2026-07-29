import '../../../models/chat_message_model.dart';

/// One row in the chat list — either a date divider or a message.
class ChatListItem {
  final bool isDivider;
  final String? dividerLabel;
  final ChatMessageModel? message;

  const ChatListItem.divider(this.dividerLabel)
      : isDivider = true,
        message = null;

  const ChatListItem.message(this.message)
      : isDivider = false,
        dividerLabel = null;
}