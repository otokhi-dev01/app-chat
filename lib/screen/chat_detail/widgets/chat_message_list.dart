import 'package:flutter/material.dart';

import '../../../models/chat_message_model.dart';
import 'chat_date.dart';
import 'chat_date_divider.dart';
import 'chat_list_item.dart';
import 'chat_message_bubble.dart';
import 'chat_message_entrance.dart';
import 'chat_scroll_to_buttom_button.dart';

class ChatMessageList extends StatefulWidget {
  final List<ChatMessageModel> messages;
  final double appBarSpace;
  final ScrollController scrollController;
  final ValueChanged<ChatMessageModel> onMessageLongPress;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.appBarSpace,
    required this.scrollController,
    required this.onMessageLongPress,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final Set<String> _seenMessageIds = <String>{};
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    for (ChatMessageModel message in widget.messages) {
      _seenMessageIds.add(message.id);
    }
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_handleScroll);
      widget.scrollController.addListener(_handleScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (!widget.scrollController.hasClients) return;

    double position = widget.scrollController.position.pixels;
    double maxExtent = widget.scrollController.position.maxScrollExtent;
    bool isAway = (maxExtent - position) > 240;

    if (isAway != _showScrollToBottom) {
      setState(() => _showScrollToBottom = isAway);
    }
  }

  List<ChatListItem> _groupByDate() {
    List<ChatListItem> items = [];
    DateTime? lastDate;

    for (ChatMessageModel message in widget.messages) {
      DateTime day = DateTime(
        message.sentAt.year,
        message.sentAt.month,
        message.sentAt.day,
      );

      if (lastDate == null || day != lastDate) {
        items.add(ChatListItem.divider(chatDateLabel(message.sentAt)));
        lastDate = day;
      }
      items.add(ChatListItem.message(message));
    }
    return items;
  }

  void _scrollToBottom() {
    if (!widget.scrollController.hasClients) return;
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ChatListItem> items = _groupByDate();

    return Stack(
      children: [
        ListView.builder(
          key: const ValueKey('message-list'),
          controller: widget.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(0, widget.appBarSpace + 8, 0, 108),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildItem(items[index], index),
        ),
        ChatScrollToBottomButton(
          visible: _showScrollToBottom,
          onTap: _scrollToBottom,
        ),
      ],
    );
  }

  Widget _buildItem(ChatListItem item, int index) {
    if (item.isDivider) {
      return KeyedSubtree(
        key: ValueKey('divider-${item.dividerLabel}-$index'),
        child: ChatDateDivider(label: item.dividerLabel!),
      );
    }

    ChatMessageModel message = item.message!;
    bool isNew = !_seenMessageIds.contains(message.id);
    _seenMessageIds.add(message.id);

    Widget bubble = ChatMessageBubble(
      message: message,
      onLongPress: () => widget.onMessageLongPress(message),
    );

    return KeyedSubtree(
      key: ValueKey(message.id),
      child: isNew ? ChatMessageEntrance(child: bubble) : bubble,
    );
  }
}