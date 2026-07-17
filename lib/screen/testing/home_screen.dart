import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: const Color(0xFF0F1012),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1012), // Deep Liquid Dark space
        body: Stack(
          children: [
            // Dynamic Tab Views
            Obx(() {
              switch (controller.currentTab.value) {
                case 0:
                  return _buildChatsTab(context, controller, colorScheme, theme);
                case 1:
                  return _buildTabPlaceholder('Contacts View');
                case 2:
                  return _buildTabPlaceholder('Settings View');
                case 3:
                  return _buildTabPlaceholder('Profile View');
                default:
                  return const SizedBox.shrink();
              }
            }),

            // Translucent Glass bottom navigation bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavigationBar(context, controller, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dynamic Tab: CHATS (Liquid Glass Style) ---
  Widget _buildChatsTab(
      BuildContext context,
      HomeController controller,
      ColorScheme colorScheme,
      ThemeData theme,
      ) {
    return Column(
      children: [
        // Custom Header mimicking 2026 Liquid Glass layout
        _buildChatsHeader(context, colorScheme, theme),

        // Chat Category Folders Bar (All, Personal, Groups, Channels)
        _buildFoldersBar(controller, colorScheme),

        // Scrollable Chat Item List
        Expanded(
          child: _buildChatList(colorScheme, theme),
        ),
      ],
    );
  }

  Widget _buildChatsHeader(BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 12,
        bottom: 12,
      ),
      child: Row(
        children: [
          Text(
            'Telegram',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white70),
            onPressed: () {},
          ),
          // 2026 Update: Side menu collapsed into this top-right 3-dot overflow menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
            color: const Color(0xFF1B1D22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) => [
              _buildPopupMenuItem('New Group', Icons.group_add_outlined, colorScheme),
              _buildPopupMenuItem('New Channel', Icons.campaign_outlined, colorScheme),
              _buildPopupMenuItem('New Secret Chat', Icons.lock_outline_rounded, colorScheme),
              _buildPopupMenuItem('Mark all as read', Icons.done_all_rounded, colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String text, IconData icon, ColorScheme colorScheme) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFoldersBar(HomeController controller, ColorScheme colorScheme) {
    final folders = ['All Chats', 'Personal', 'Work', 'Channels'];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.activeChatFolder.value == index;
            return GestureDetector(
              onTap: () => controller.changeChatFolder(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  folders[index],
                  style: TextStyle(
                    color: isSelected ? colorScheme.primary : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildChatList(ColorScheme colorScheme, ThemeData theme) {
    final List<Map<String, dynamic>> mockChats = [
      {
        'name': 'Pavel Durov',
        'message': 'Liquid Glass update is officially live!',
        'time': '16:41',
        'unread': 1,
        'isOnline': true,
        'isRead': false,
        'avatarColor': Colors.blue,
        'initials': 'PD',
      },
      {
        'name': 'Flutter Dev Group',
        'message': 'Alex: Check out this new GetX + BackdropFilter UI template.',
        'time': '15:30',
        'unread': 14,
        'isOnline': false,
        'isRead': false,
        'avatarColor': Colors.teal,
        'initials': 'FD',
      },
      {
        'name': 'Sarah Jenkins',
        'message': 'Did you review the new country picker design?',
        'time': 'Yesterday',
        'unread': 0,
        'isOnline': true,
        'isRead': true,
        'avatarColor': Colors.purple,
        'initials': 'SJ',
      },
      {
        'name': 'Telegram Channels',
        'message': 'AI Summaries are now supported on channel posts!',
        'time': 'Jan 3',
        'unread': 0,
        'isOnline': false,
        'isRead': true,
        'avatarColor': Colors.orange,
        'initials': 'TC',
      }
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
      itemCount: mockChats.length,
      itemBuilder: (context, index) {
        final chat = mockChats[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03), // Liquid Glass Refraction Layer
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.04),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Avatar with Online indicator ring
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: chat['avatarColor'].withValues(alpha: 0.15),
                    child: Text(
                      chat['initials'],
                      style: TextStyle(
                        color: chat['avatarColor'],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (chat['isOnline'])
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0F1012), width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Chat name and subtitle message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat['message'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Timestamps and unread badges
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      if (chat['isRead'])
                        Icon(
                          Icons.done_all_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        chat['time'],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (chat['unread'] > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${chat['unread']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // --- End of Dynamic Tab: CHATS ---

  Widget _buildTabPlaceholder(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context,
      HomeController controller,
      ColorScheme colorScheme,
      ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16171A).withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(controller, 0, Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Chats', colorScheme, badgeCount: 4),
                  _buildNavItem(controller, 1, Icons.people_alt_outlined, Icons.people_alt_rounded, 'Contacts', colorScheme),
                  _buildNavItem(controller, 2, Icons.settings_outlined, Icons.settings_rounded, 'Settings', colorScheme),
                  _buildNavItem(controller, 3, Icons.account_circle_outlined, Icons.account_circle_rounded, 'Profile', colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      HomeController controller,
      int index,
      IconData inactiveIcon,
      IconData activeIcon,
      String label,
      ColorScheme colorScheme, {
        int badgeCount = 0,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: Obx(() {
          final isSelected = controller.currentTab.value == index;
          final color = isSelected ? colorScheme.primary : Colors.white.withValues(alpha: 0.4);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    color: color,
                    size: 24,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}