import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../models/home_model.dart';
/// Full-screen search, opened from the search icon or the pinned
/// search bar that appears when the chat list is scrolled down.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            controller.searchController.clear();
            controller.searchQuery.value = '';
            Get.back();
          },
        ),
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  autofocus: true,
                  onChanged: (value) =>
                  controller.searchQuery.value = value,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Search chats',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              Obx(
                    () => controller.searchQuery.value.isNotEmpty
                    ? GestureDetector(
                  onTap: () {
                    controller.searchController.clear();
                    controller.searchQuery.value = '';
                  },
                  child: const Icon(Icons.close_rounded, size: 18),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        final String query = controller.searchQuery.value;
        final List<ChatModel> results = controller.searchAllChats(query);

        if (query.trim().isEmpty) {
          return Center(
            child: Text(
              'Search chats by name or message',
              style: TextStyle(
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
          );
        }

        if (results.isEmpty) {
          return Center(
            child: Text(
              'No results for "$query"',
              style: TextStyle(
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: results.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: 72,
            color: isDark ? Colors.white12 : Colors.black12,
          ),
          itemBuilder: (context, index) {
            final ChatModel chat = results[index];

            return ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(chat.image),
              ),
              title: Text(
                chat.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                chat.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.grey.shade500
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (chat.unread > 0) ...[
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 9,
                      child: Text(
                        '${chat.unread}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ],
              ),
              onTap: () {
                // TODO: navigate to the chat detail screen
              },
            );
          },
        );
      }),
    );
  }
}