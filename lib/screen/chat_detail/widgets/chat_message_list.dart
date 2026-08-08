import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/chat_message_model.dart';
import 'chat_date.dart';
import 'chat_date_divider.dart';
import 'chat_list_item.dart';
import 'chat_message_bubble.dart';
import 'chat_message_entrance.dart';
import 'chat_scroll_to_bottom_button.dart';

/// UPDATED: Unit UI chat message list view handling date grouping, scroll tracking, and entrance animations
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
  // UPDATED: Tracks seen message IDs so entrance animation only plays for newly added messages
  final Set<String> _seenMessageIds = <String>{};
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    // ADDED: Pre-populate existing message IDs so initial page load doesn't trigger entrance animations
    for (ChatMessageModel message in widget.messages) {
      _seenMessageIds.add(message.id);
    }
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // UPDATED: Rebind scroll listener if scroll controller reference changes
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

  /// UPDATED: Monitors scroll offset to toggle scroll-to-bottom FAB visibility when >240px away from bottom
  void _handleScroll() {
    if (!widget.scrollController.hasClients) return;

    double position = widget.scrollController.position.pixels;
    double maxExtent = widget.scrollController.position.maxScrollExtent;
    bool isAway = (maxExtent - position) > 240;

    if (isAway != _showScrollToBottom) {
      setState(() => _showScrollToBottom = isAway);
    }
  }

  /// UPDATED: Groups chat messages by date and inserts ChatDateDivider items
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

  /// UPDATED: Smoothly animates to bottom with haptic feedback
  void _scrollToBottom() {
    if (!widget.scrollController.hasClients) return;
    HapticFeedback.lightImpact(); // ADDED: Tactile feedback on scroll-to-bottom button tap

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
        // UPDATED: Main scrollable message list with iOS bouncing physics and drag-to-dismiss keyboard
        ListView.builder(
          key: const ValueKey('message-list'),
          controller: widget.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          // UPDATED: Top padding clears translucent app bar (appBarSpace + 8) and bottom clears floating input bar (108px)
          padding: EdgeInsets.fromLTRB(0, widget.appBarSpace + 8, 0, 108),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildItem(items[index], index),
        ),

        // UPDATED: Floating scroll-to-bottom action button
        ChatScrollToBottomButton(
          visible: _showScrollToBottom,
          onTap: _scrollToBottom,
        ),
      ],
    );
  }

  /// UPDATED: Renders date dividers or message bubbles with entrance animation for newly added items
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