import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../../widgets/archived/archived_chats_actions_sheet.dart';
import '../../widgets/archived/archived_chats_app_bar.dart';
import '../../widgets/archived/archived_chats_empty_state.dart';
import '../../widgets/archived/archived_chats_title.dart';
import '../../widgets/common/app_feedback.dart';

class ArchivedChatsScreen extends StatefulWidget {
  final List<ChatModel> archivedChats;
  final ValueChanged<ChatModel> onUnarchive;
  final ValueChanged<ChatModel> onDelete;
  final ValueChanged<ChatModel> onToggleMute;
  final void Function(ChatModel chat) onOpenChat;

  const ArchivedChatsScreen({
    super.key,
    required this.archivedChats,
    required this.onUnarchive,
    required this.onDelete,
    required this.onToggleMute,
    required this.onOpenChat,
  });

  @override
  State<ArchivedChatsScreen> createState() {
    return _ArchivedChatsScreenState();
  }
}

class _ArchivedChatsScreenState extends State<ArchivedChatsScreen> {
  late List<ChatModel> chats;

  @override
  void initState() {
    super.initState();

    chats = List<ChatModel>.from(
      widget.archivedChats,
    );
  }

  void _replaceChat(ChatModel updatedChat) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == updatedChat.id;
      },
    );

    if (index < 0) {
      return;
    }

    setState(() {
      chats[index] = updatedChat;
    });
  }

  void _unarchiveChat(ChatModel chat) {
    int index = chats.indexWhere(
          (ChatModel item) {
        return item.id == chat.id;
      },
    );

    if (index < 0) {
      return;
    }

    ChatModel updatedChat = chat.copyWith(
      isArchived: false,
    );

    setState(() {
      chats.removeAt(index);
    });

    widget.onUnarchive(updatedChat);

    _showMessage(
      '${chat.name} ${'was_unarchived'.tr}',
      icon: CupertinoIcons.archivebox,
    );
  }

  void _deleteChat(ChatModel chat) {
    setState(() {
      chats.removeWhere(
            (ChatModel item) {
          return item.id == chat.id;
        },
      );
    });

    widget.onDelete(chat);

    _showMessage(
      '${chat.name} ${'was_deleted'.tr}',
      icon: CupertinoIcons.trash,
      isError: true,
    );
  }

  void _toggleMute(ChatModel chat) {
    ChatModel updatedChat = chat.copyWith(
      isMuted: !chat.isMuted,
    );

    _replaceChat(updatedChat);
    widget.onToggleMute(updatedChat);

    _showMessage(
      updatedChat.isMuted
          ? '${chat.name} ${'was_muted'.tr}'
          : '${chat.name} ${'was_unmuted'.tr}',
      icon: updatedChat.isMuted
          ? CupertinoIcons.bell_slash
          : CupertinoIcons.bell,
    );
  }

  void _openChat(ChatModel chat) {
    widget.onOpenChat(chat);
  }

  void _showMessage(
      String message, {
        required IconData icon,
        bool isError = false,
      }) {
    AppFeedback.showMessage(
      title: isError ? 'error'.tr : 'success'.tr,
      message: message,
      icon: icon,
    );
  }

  Future<void> _showChatActions(
      ChatModel chat,
      ) async {
    await ArchivedChatActionsSheet.show(
      context: context,
      chat: chat,
      onUnarchive: () => _unarchiveChat(chat),
      onMuteToggle: () => _toggleMute(chat),
      onDelete: () => _deleteChat(chat),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ArchivedChatsAppBar(
        archivedCount: chats.length,
        onBack: () {
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: Duration(
            milliseconds: 280,
          ),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: chats.isEmpty
              ? ArchivedChatsEmptyState(
            key: ValueKey<String>(
              'archived-empty',
            ),
          )
              : ListView.builder(
            key: ValueKey<String>(
              'archived-list',
            ),
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              0,
              9,
              0,
              30,
            ),
            itemCount: chats.length,
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              ChatModel chat = chats[index];

              return ArchivedChatTile(
                key: ValueKey<String>(
                  chat.id,
                ),
                chat: chat,
                onTap: () {
                  _openChat(chat);
                },
                onLongPress: () {
                  _showChatActions(chat);
                },
                onSwipeUnarchive: () {
                  _unarchiveChat(chat);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}