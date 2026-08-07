import 'package:flutter/material.dart';

import '../../../models/chat_message_model.dart';
import 'chat_empty_conversation.dart';
import 'chat_input_bar.dart';
import 'chat_message_list.dart';

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

  final ValueChanged<ChatMessageModel> onMessageLongPress;

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

  const ChatDetailContent({
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
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: messages.isEmpty
                ? _buildEmptyConversation()
                : ChatMessageList(
              key: const ValueKey('message-list-wrapper'),
              messages: messages,
              appBarSpace: appBarSpace,
              scrollController: scrollController,
              onMessageLongPress: onMessageLongPress,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ChatInputBar(
            key: const ValueKey('chat-input-bar'),
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
      key: const ValueKey('empty-conversation'),
      child: Padding(
        padding: EdgeInsets.only(top: appBarSpace, bottom: 100),
        child: ChatEmptyConversation(name: chatName),
      ),
    );
  }
}