import 'package:appchat/controllers/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Haptics
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../chat_detail/chat_detail_screen.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;

  const ChatTile({
    super.key,
    required this.chat,
  });

  String _formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    bool isToday = now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day;

    if (isToday) {
      int hour = dateTime.hour;
      String period = hour >= 12 ? 'PM' : 'AM';

      int formattedHour = hour % 12;

      if (formattedHour == 0) {
        formattedHour = 12;
      }

      String minute = dateTime.minute.toString().padLeft(2, '0');

      return '$formattedHour:$minute $period';
    }

    DateTime yesterday = now.subtract(
      const Duration(days: 1),
    );

    bool isYesterday = yesterday.year == dateTime.year && yesterday.month == dateTime.month && yesterday.day == dateTime.day;

    if (isYesterday) {
      return 'Yesterday';
    }

    if (now.year == dateTime.year) {
      return '${dateTime.day}/${dateTime.month}';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _getFirstLetter() {
    String name = chat.name.trim();

    if (name.isEmpty) {
      return '?';
    }

    return name[0].toUpperCase();
  }

  void _openChatDetail() {
    // Play subtle iOS-style tap feedback on opening chats
    HapticFeedback.lightImpact();

    if (Get.isRegistered<ChatController>()) {
      ChatController controller = Get.find<ChatController>();

      controller.markAsRead(chat.id);
    }

    Get.to(
          () => ChatDetailScreen(
        chat: chat,
      ),
      transition: Transition.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: _BouncyChatTile(
        onTap: _openChatDetail,
        onLongPress: () {
          _showChatActions(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          child: Row(
            children: [
              _buildAvatar(context, isDark, primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChatContent(primaryColor),
              ),
              const SizedBox(width: 8),
              _buildTrailing(primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(
      BuildContext context,
      bool isDark,
      Color primaryColor,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: primaryColor.withValues(
            alpha: 0.15,
          ),
          child: Text(
            _getFirstLetter(),
            style: TextStyle(
              color: primaryColor,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (chat.type == 'group')
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 19,
              height: 19,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  // Set to match Telegram dark mode background color (0xFF0E1621)
                  color: isDark ? const Color(0xFF0E1621) : Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.group_rounded,
                color: Colors.white,
                size: 11,
              ),
            ),
          ),
        if (chat.isOnline && chat.type == 'personal')
          Positioned(
            right: 0,
            bottom: 1,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  // Set to match Telegram dark mode background color (0xFF0E1621)
                  color: isDark ? const Color(0xFF0E1621) : Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChatContent(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                chat.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: chat.unread > 0 ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
            if (chat.isPinned)
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.push_pin_rounded,
                  size: 15,
                  color: Colors.grey,
                ),
              ),
            if (chat.isMuted)
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.volume_off_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            if (chat.isMe) ...[
              Icon(
                chat.status == MessageStatus.read ? Icons.done_all_rounded : Icons.done_rounded,
                size: 17,
                color: chat.status == MessageStatus.read ? primaryColor : Colors.grey,
              ),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                chat.isTyping ? 'Typing...' : chat.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: chat.isTyping ? primaryColor : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: chat.isTyping ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrailing(Color primaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatDateTime(chat.dateTime),
          style: TextStyle(
            color: chat.unread > 0 ? primaryColor : Colors.grey.shade600,
            fontSize: 11,
            fontWeight: chat.unread > 0 ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 7),
        if (chat.unread > 0)
          Container(
            constraints: const BoxConstraints(
              minWidth: 21,
              minHeight: 21,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: chat.isMuted ? Colors.grey : primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              chat.unread > 99 ? '99+' : chat.unread.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          const SizedBox(height: 21),
      ],
    );
  }

  void _showChatActions(BuildContext context) {
    if (!Get.isRegistered<ChatController>()) {
      return;
    }

    ChatController controller = Get.find<ChatController>();

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  chat.isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
                ),
                title: Text(
                  chat.isPinned ? 'Unpin conversation' : 'Pin conversation',
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.togglePin(chat.id);
                },
              ),
              ListTile(
                leading: Icon(
                  chat.isMuted ? Icons.notifications_outlined : Icons.notifications_off_outlined,
                ),
                title: Text(
                  chat.isMuted ? 'Unmute notifications' : 'Mute notifications',
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.toggleMute(chat.id);
                },
              ),
              if (chat.unread > 0)
                ListTile(
                  leading: const Icon(
                    Icons.mark_chat_read_outlined,
                  ),
                  title: const Text('Mark as read'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.markAsRead(chat.id);
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete conversation',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.deleteChat(chat.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------
// 3. Private elastic press handler to keep the tile stateless
// ---------------------------------------------------------------------
class _BouncyChatTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _BouncyChatTile({
    required this.child,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<_BouncyChatTile> createState() => _BouncyChatTileState();
}

class _BouncyChatTileState extends State<_BouncyChatTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      onLongPress: () {
        setState(() {
          _isPressed = false;
        });
        widget.onLongPress?.call();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}