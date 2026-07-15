import 'package:flutter/material.dart';

import '../../../models/chat_message_model.dart';
import 'chat_date_divider.dart';
import 'chat_empty_conversation.dart';
import 'chat_input_bar.dart';
import 'chat_message_bubble.dart';

class ChatDetailContent extends StatelessWidget {
  final String chatName;
  final List<ChatMessageModel> messages;

  final double appBarSpace;

  final ScrollController scrollController;
  final TextEditingController messageController;
  final FocusNode messageFocusNode;

  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onCamera;

  final ValueChanged<ChatMessageModel>
  onMessageLongPress;

  final bool isRecording;
  final bool isHoldRecording;

  final double voiceDragDx;
  final double cancelThreshold;

  final VoidCallback onVoiceTap;
  final VoidCallback onVoiceStart;
  final ValueChanged<double> onVoiceDrag;
  final VoidCallback onVoiceEnd;
  final VoidCallback onVoiceCancel;
  final ValueChanged<Duration> onVoiceSend;

  ChatDetailContent({
    super.key,
    required this.chatName,
    required this.messages,
    required this.appBarSpace,
    required this.scrollController,
    required this.messageController,
    required this.messageFocusNode,
    required this.onSend,
    required this.onAttachment,
    required this.onCamera,
    required this.onMessageLongPress,
    required this.isRecording,
    required this.isHoldRecording,
    required this.voiceDragDx,
    required this.cancelThreshold,
    required this.onVoiceTap,
    required this.onVoiceStart,
    required this.onVoiceDrag,
    required this.onVoiceEnd,
    required this.onVoiceCancel,
    required this.onVoiceSend,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: Duration(
              milliseconds: 250,
            ),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: messages.isEmpty
                ? _buildEmptyConversation()
                : _buildMessageList(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ChatInputBar(
            key: ValueKey('chat-input-bar'),
            controller: messageController,
            focusNode: messageFocusNode,
            onSend: onSend,
            onAttachment: onAttachment,
            onCamera: onCamera,
            isRecording: isRecording,
            isHoldRecording: isHoldRecording,
            voiceDragDx: voiceDragDx,
            cancelThreshold: cancelThreshold,
            onVoiceTap: onVoiceTap,
            onVoiceStart: onVoiceStart,
            onVoiceDrag: onVoiceDrag,
            onVoiceEnd: onVoiceEnd,
            onVoiceCancel: onVoiceCancel,
            onVoiceSend: onVoiceSend,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyConversation() {
    return KeyedSubtree(
      key: ValueKey('empty-conversation'),
      child: Padding(
        padding: EdgeInsets.only(
          top: appBarSpace,
          bottom: 100,
        ),
        child: ChatEmptyConversation(
          name: chatName,
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      key: ValueKey('message-list'),
      controller: scrollController,
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        0,
        appBarSpace + 8,
        0,
        108,
      ),
      itemCount: messages.length + 1,
      itemBuilder: (
          BuildContext context,
          int index,
          ) {
        if (index == 0) {
          return ChatDateDivider(
            label: 'Today',
          );
        }

        ChatMessageModel message =
        messages[index - 1];

        return KeyedSubtree(
          key: ValueKey(message.id),
          child: ChatMessageBubble(
            message: message,
            onLongPress: () {
              onMessageLongPress(message);
            },
          ),
        );
      },
    );
  }
}