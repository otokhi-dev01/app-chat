import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/home_controller.dart';
import '../../models/home_model.dart';
import '../widgets/chat_title.dart';

class HomeChatList extends StatelessWidget {
  final HomeController controller;

  const HomeChatList({
    super.key,
    required this.controller,
  });

  List<ChatModel> _filterChats(
      List<ChatModel> chats,
      int categoryIndex,
      ) {
    switch (categoryIndex) {
      case 1:
        return chats
            .where((chat) => chat.unread > 0)
            .toList();

      case 2:
        return chats
            .where((chat) => chat.type == 'personal')
            .toList();

      case 3:
        return chats
            .where((chat) => chat.type == 'group')
            .toList();

      default:
        return chats;
    }
  }

  String _emptyMessage(int categoryIndex) {
    switch (categoryIndex) {
      case 1:
        return 'No unread conversations';

      case 2:
        return 'No personal conversations';

      case 3:
        return 'No group conversations';

      default:
        return 'No conversations found';
    }
  }

  IconData _emptyIcon(int categoryIndex) {
    switch (categoryIndex) {
      case 1:
        return Icons.mark_chat_read_outlined;

      case 2:
        return Icons.person_outline_rounded;

      case 3:
        return Icons.groups_outlined;

      default:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int categoryIndex =
          controller.selectedCategoryIndex.value;

      final bool isLoading =
          controller.isLoading.value;

      final String errorMessage =
          controller.errorMessage.value;

      final List<ChatModel> allChats =
      controller.chats.toList();

      final List<ChatModel> filteredChats =
      _filterChats(
        allChats,
        categoryIndex,
      );

      if (isLoading && allChats.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (errorMessage.isNotEmpty &&
          allChats.isEmpty) {
        return _ChatErrorWidget(
          message: errorMessage,
          onRetry: controller.retry,
        );
      }

      if (filteredChats.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.refreshChats,
          child: ListView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 160),
              Icon(
                _emptyIcon(categoryIndex),
                size: 68,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  _emptyMessage(categoryIndex),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshChats,
        child: ListView.separated(
          physics:
          const AlwaysScrollableScrollPhysics(),
          itemCount: filteredChats.length,
          separatorBuilder: (_, __) {
            return const Divider(
              height: 1,
              indent: 80,
            );
          },
          itemBuilder: (context, index) {
            return ChatTile(
              chat: filteredChats[index],
            );
          },
        ),
      );
    });
  }
}

class _ChatErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ChatErrorWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}