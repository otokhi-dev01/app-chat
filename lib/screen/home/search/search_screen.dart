import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/search/search_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../data/mock_chat_data.dart';
import '../../../models/chat_model.dart';
import '../../../services/search_service/search_history_service.dart';
import '../../chat_detail/chat_detail_screen.dart';
import '../../profile/details_profile/profile_detail_screen.dart';
import 'search_scope_selector.dart';

/// UPDATED: Unit UI SearchScreen with glassmorphism blurred header, 40x40 circular back button, and unit UI colors
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  late final ChatSearchController controller;
  late final List<ChatModel> mockChats;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<ChatSearchController>()
        ? Get.find<ChatSearchController>()
        : Get.put(ChatSearchController());

    mockChats = MockChatData.build();
  }

  void _closeSearch(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Get.back();
  }

  void _clearSearch() {
    controller.clearSearch();
  }

  Future<void> _openChat(ChatModel chat) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final String query = controller.searchQuery.value.trim();
    if (query.isNotEmpty) {
      await controller.addHistory(query);
    }

    await controller.addVisitedUser(VisitedUser.fromChat(chat));

    await Get.to(
      () => ChatDetailScreen(chat: chat),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 280),
    );
  }

  void _openUserProfile(ChatModel chat) {
    FocusManager.instance.primaryFocus?.unfocus();

    controller.addVisitedUser(VisitedUser.fromChat(chat));

    final UserController userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());

    userController.name.value = chat.name;
    userController.profileImageUrl.value = chat.image;
    userController.status.value = chat.isOnline ? 'Online' : 'Offline';
    userController.username.value =
        '@${chat.name.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}';

    Get.to(
      () => ProfileDetailScreen(controller: userController),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 280),
    );
  }

  void _openVisitedUserProfile(VisitedUser user) {
    FocusManager.instance.primaryFocus?.unfocus();

    controller.addVisitedUser(user);

    final UserController userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());

    userController.name.value = user.name;
    userController.profileImageUrl.value = user.image;
    userController.status.value = user.isOnline ? 'Online' : 'Offline';
    userController.username.value =
        '@${user.name.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}';

    Get.to(
      () => ProfileDetailScreen(controller: userController),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 280),
    );
  }

  Future<void> _openVisitedUserChat(VisitedUser visited) async {
    FocusManager.instance.primaryFocus?.unfocus();

    ChatModel? matchingChat;
    try {
      matchingChat = mockChats.firstWhere(
        (ChatModel c) =>
            c.id == visited.id ||
            c.name.trim().toLowerCase() == visited.name.trim().toLowerCase(),
      );
    } catch (_) {
      matchingChat = ChatModel(
        id: visited.id.isNotEmpty
            ? visited.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: visited.name,
        message: visited.message,
        dateTime: DateTime.now(),
        type: visited.type,
        image: visited.image,
        isOnline: visited.isOnline,
      );
    }

    await _openChat(matchingChat);
  }

  Future<void> _confirmClearHistory(BuildContext context) async {
    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('clear_search_history_title'.tr),
          content: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('clear_search_history_confirm'.tr),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('cancel'.tr),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('clear'.tr),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await controller.clearHistory();
    }
  }

  SystemUiOverlayStyle _overlayStyle(
      ThemeData theme,
      bool isDark,
      ) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  List<ChatModel> _getSearchResults() {
    final String query = controller.searchQuery.value.trim().toLowerCase();
    final SearchScope scope = controller.selectedScope.value;

    if (query.isEmpty) {
      return <ChatModel>[];
    }

    return mockChats.where((ChatModel chat) {
      if (chat.isArchived) {
        return false;
      }

      bool scopeMatches = true;

      if (scope == SearchScope.contacts) {
        scopeMatches = chat.type == 'personal';
      }

      if (scope == SearchScope.chats) {
        scopeMatches = chat.type == 'personal' ||
            chat.type == 'group' ||
            chat.type == 'saved';
      }

      if (!scopeMatches) {
        return false;
      }

      final String name = chat.name.toLowerCase();
      final String message = chat.message.toLowerCase();

      return name.contains(query) || message.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final SystemUiOverlayStyle overlayStyle = _overlayStyle(theme, isDark);

    // FIXED: Calculate top padding to clear glassmorphic translucent AppBar
    final double topSpace = MediaQuery.of(context).padding.top + 68;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: PopScope(
        onPopInvokedWithResult: (
            bool didPop,
            Object? result,
            ) {
          if (didPop) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        // FIXED: Enabled extendBodyBehindAppBar so glass backdrop filter extends into top status bar
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: _buildAppBar(context, overlayStyle),
          body: Padding(
            padding: EdgeInsets.only(top: topSpace),
            child: Obx(() {
              return _buildBody(context);
            }),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      SystemUiOverlayStyle overlayStyle,
      ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    // UPDATED: Standardized unit UI glassmorphism colors and dark #1B1D22 palette
    final Color headerColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    final Color actionBackground =
    isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color searchBackground =
    isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return AppBar(
      toolbarHeight: 68,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      titleSpacing: 0,
      leadingWidth: 58,
      systemOverlayStyle: overlayStyle,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: headerColor,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      // UPDATED: 40x40 elevated circular back button matching unit UI standards
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 6, 14),
        child: Container(
          width: 40,
          height: 40,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: actionBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.15 : 0.04,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(40, 40),
            onPressed: () {
              _closeSearch(context);
            },
            child: Icon(
              CupertinoIcons.chevron_left,
              size: 20,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
      // UPDATED: Floating search bar with 22px border radius, CupertinoIcons.search, and clear button
      title: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: searchBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.15 : 0.04,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(
                CupertinoIcons.search,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.searchTextController,
                  autofocus: true,
                  onChanged: controller.updateSearch,
                  onSubmitted: (String value) {
                    controller.search(value);
                  },
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: colorScheme.primary,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'search_chats'.tr,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? Colors.white.withValues(
                        alpha: 0.4,
                      )
                          : Colors.black.withValues(
                        alpha: 0.4,
                      ),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 11,
                    ),
                  ),
                  onTapOutside: (
                      PointerDownEvent event,
                      ) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
              Obx(() {
                if (controller.searchQuery.value.isEmpty) {
                  return const SizedBox(width: 12);
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(32, 32),
                    onPressed: _clearSearch,
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      size: 18,
                      color: isDark
                          ? Colors.white.withValues(
                        alpha: 0.4,
                      )
                          : Colors.black.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final String query = controller.searchQuery.value.trim();

    if (query.isEmpty) {
      return _buildHistoryView(context);
    }

    final List<ChatModel> results = _getSearchResults();

    return Column(
      children: [
        // REPLACED: Extracted SearchScopeSelector widget
        SearchScopeSelector(
          selectedScope: controller.selectedScope.value,
          onScopeChanged: (SearchScope scope) {
            controller.changeScope(scope);
          },
        ),
        Expanded(
          child: results.isEmpty
              ? _buildEmptyResult(context, query)
              : ListView.separated(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 6,
              bottom: 30,
            ),
            itemCount: results.length,
            separatorBuilder: (
                BuildContext context,
                int index,
                ) {
              return Divider(
                height: 1,
                indent: 82,
                endIndent: 14,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.35),
              );
            },
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              return _buildChatTile(
                context,
                results[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryView(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final bool hasVisited = controller.visitedUsers.isNotEmpty;
    final bool hasSearches = controller.searchHistory.isNotEmpty;

    if (!hasVisited && !hasSearches) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // UPDATED: 72x72 circular primary icon container matching unit UI empty state standards
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: 0.11,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.search,
                  color: colorScheme.primary,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'search_chats'.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'search_hint_description'.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final Color cardBackground =
        isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        30,
      ),
      children: [
        // SECTION 1: Recently Visited Users / Profiles
        if (hasVisited) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: 2,
              right: 2,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_crop_circle,
                      size: 17,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'recent_visited'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () {
                    controller.clearVisitedUsers();
                  },
                  child: Text(
                    'clear_all'.tr,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.visitedUsers.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 14);
              },
              itemBuilder: (BuildContext context, int index) {
                final VisitedUser user = controller.visitedUsers[index];
                final bool hasImage = user.image.trim().isNotEmpty;

                return SizedBox(
                  width: 68,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openVisitedUserProfile(user);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.surfaceContainerHighest,
                                border: Border.all(
                                  color: borderColor,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: isDark ? 0.2 : 0.06,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: hasImage
                                    ? Image.network(
                                        user.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace,
                                        ) {
                                          return Icon(
                                            CupertinoIcons.person_fill,
                                            size: 28,
                                            color: colorScheme.onSurfaceVariant,
                                          );
                                        },
                                      )
                                    : Icon(
                                        CupertinoIcons.person_fill,
                                        size: 28,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                              ),
                            ),
                            if (user.isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF34C759),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.scaffoldBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          _openVisitedUserChat(user);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            user.name.split(' ').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
        ],

        // SECTION 2: Recent Searches Keywords
        if (hasSearches) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: 2,
              right: 2,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'recent_searches'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () {
                    _confirmClearHistory(context);
                  },
                  child: Text(
                    'clear_all'.tr,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.15 : 0.04,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: controller.searchHistory.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  indent: 52,
                  endIndent: 12,
                  color: borderColor,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final String query = controller.searchHistory[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      controller.selectHistory(query);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.surfaceContainerHighest.withValues(
                                alpha: isDark ? 0.4 : 0.6,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              CupertinoIcons.time,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              query,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(28, 28),
                            onPressed: () {
                              controller.removeHistory(query);
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.xmark,
                                size: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyResult(
      BuildContext context,
      String query,
      ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // UPDATED: 72x72 circular search container for empty result state
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: colorScheme.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'no_results_found'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'no_chats_match'.trParams({
                'query': query,
              }),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile(
      BuildContext context,
      ChatModel chat,
      ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool hasImage = chat.image.trim().isNotEmpty;

    final IconData fallbackIcon = chat.type == 'group'
        ? CupertinoIcons.person_3_fill
        : CupertinoIcons.person_fill;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _openChat(chat);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _openUserProfile(chat);
                },
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  backgroundImage: hasImage ? NetworkImage(chat.image) : null,
                  child: hasImage
                      ? null
                      : Icon(
                          fallbackIcon,
                          color: colorScheme.onSurfaceVariant,
                          size: 26,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                              fontWeight: chat.unread > 0
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (chat.isPinned)
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              CupertinoIcons.pin_fill,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      chat.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(chat.dateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
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
                        color: chat.isMuted
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        chat.unread > 99 ? '99+' : chat.unread.toString(),
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final DateTime now = DateTime.now();

    final bool isToday = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      final String hour = dateTime.hour.toString().padLeft(2, '0');

      final String minute = dateTime.minute.toString().padLeft(2, '0');

      return '$hour:$minute';
    }

    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime messageDay = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    final int difference = today.difference(messageDay).inDays;

    if (difference == 1) {
      return 'yesterday'.tr;
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}