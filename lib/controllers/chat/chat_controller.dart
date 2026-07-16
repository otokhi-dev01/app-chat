import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../../route/app_route.dart';
import '../../screen/chat_detail/chat_detail_screen.dart';
import '../../screen/home/archived_chat/archived_chat_screen.dart';
import '../../screen/home/search/search_screen.dart';

class ChatController extends GetxController {
  final RxList<ChatModel> chats = <ChatModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool showHomeSearchBar = true.obs;

  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;

  final RxInt selectedCategoryIndex = 0.obs;

  TextEditingController? _searchTextController;

  TextEditingController get searchTextController {
    return _searchTextController ??=
        TextEditingController(
          text: searchQuery.value,
        );
  }

  final List<String> categories = [
    'All',
    'Unread',
    'Personal',
    'Groups',
  ];

  @override
  void onInit() {
    super.onInit();

    loadChats();
  }

  Future<void> openSearchScreen() async {
    if (isSearching.value) {
      return;
    }

    isSearching.value = true;

    FocusManager.instance.primaryFocus?.unfocus();

    // Always create a fresh controller when opening search.
    _disposeSearchTextController();

    _searchTextController =
        TextEditingController(
          text: searchQuery.value,
        );

    _searchTextController!.selection =
        TextSelection.collapsed(
          offset: _searchTextController!.text.length,
        );

    try {
      await Get.to(
            () => SearchScreen(
          controller: this,
        ),
        transition: Transition.fadeIn,
        duration: Duration(
          milliseconds: 220,
        ),
      );
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();

      searchQuery.value = '';
      _disposeSearchTextController();

      isSearching.value = false;
    }
  }

  /// Opens the Telegram-style Archived Chats screen and keeps the main
  /// chats list in sync with whatever the user does there (unarchive,
  /// mute toggle, delete).
  Future<void> openArchivedChatsScreen() async {
    await Get.to(
          () => ArchivedChatsScreen(
        archivedChats: archivedChats,
        onUnarchive: (ChatModel chat) {
          unarchiveChat(chat.id);
        },
        onDelete: (ChatModel chat) {
          deleteChat(chat.id);
        },
        onToggleMute: (ChatModel chat) {
          updateChat(chat);
        },
        onOpenChat: (ChatModel chat) {
          Get.to(
                () => ChatDetailScreen(chat: chat),
          );
        },
      ),
      transition: Transition.fadeIn,
      duration: Duration(
        milliseconds: 220,
      ),
    );
  }

  Future<void> openSettingsScreen() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await Get.toNamed(
      AppRoutes.settings,
    );
  }

  void handleChatScroll(
      UserScrollNotification notification,
      ) {
    if (notification.depth != 0) {
      return;
    }

    double offset = notification.metrics.pixels;

    if (offset <= 5) {
      showHomeSearchBar.value = false;
      return;
    }

    if (notification.direction ==
        ScrollDirection.reverse) {
      if (!showHomeSearchBar.value) {
        showHomeSearchBar.value = true;
      }
    } else if (notification.direction ==
        ScrollDirection.forward) {
      if (showHomeSearchBar.value) {
        showHomeSearchBar.value = false;
      }
    }
  }

  void showSearchBar() {
    showHomeSearchBar.value = true;
  }

  void hideSearchBar() {
    showHomeSearchBar.value = false;
  }

  Future<void> loadChats() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(
        Duration(milliseconds: 300),
      );

      List<ChatModel> loadedChats = [
        ChatModel(
          id: '1',
          name: 'Alex Morgan',
          message: 'See you tomorrow!',
          dateTime: DateTime.now().subtract(
            Duration(minutes: 5),
          ),
          type: 'personal',
          unread: 2,
          isOnline: true,
          status: MessageStatus.delivered,
        ),
        ChatModel(
          id: '2',
          name: 'Design Team',
          message:
          'Chloe: Uploaded the new mockups',
          dateTime: DateTime.now().subtract(
            Duration(hours: 2),
          ),
          type: 'group',
          isPinned: true,
        ),
        ChatModel(
          id: '3',
          name: 'Daniel Kim',
          message: 'Typing...',
          dateTime: DateTime.now().subtract(
            Duration(hours: 5),
          ),
          type: 'personal',
          isTyping: true,
        ),
        ChatModel(
          id: '4',
          name: 'Emma Watson',
          message: 'Thanks a lot 🙏',
          dateTime: DateTime.now().subtract(
            Duration(days: 1),
          ),
          type: 'personal',
          isMe: true,
          status: MessageStatus.read,
        ),
        ChatModel(
          id: '5',
          name: 'Project Alpha',
          message:
          'George: Let\'s catch up this weekend',
          dateTime: DateTime.now().subtract(
            Duration(days: 3),
          ),
          type: 'group',
          isMuted: true,
        ),
      ];

      chats.assignAll(loadedChats);

      _sortChats();
    } catch (error) {
      errorMessage.value =
      'Failed to load chats: $error';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshChats() async {
    await loadChats();
  }

  Future<void> retry() async {
    await loadChats();
  }

  void selectCategory(int index) {
    if (index < 0 ||
        index >= categories.length) {
      return;
    }

    selectedCategoryIndex.value = index;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchQuery.value = '';

    TextEditingController? textController =
        _searchTextController;

    if (textController != null &&
        textController.text.isNotEmpty) {
      textController.clear();
    }
  }

  List<ChatModel> get searchResults {
    String query =
    searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    return chats.where(
          (ChatModel chat) {
        if (chat.isArchived) {
          return false;
        }

        bool matchesName = chat.name
            .toLowerCase()
            .contains(query);

        bool matchesMessage = chat.message
            .toLowerCase()
            .contains(query);

        return matchesName || matchesMessage;
      },
    ).toList();
  }

  /// Chats shown on the main list. Archived chats are deliberately
  /// excluded here — they only appear inside the Archived Chats screen,
  /// reached via the collapsed summary row.
  List<ChatModel> get filteredChats {
    Iterable<ChatModel> result = chats.where(
          (ChatModel chat) {
        return !chat.isArchived;
      },
    );

    int categoryIndex =
        selectedCategoryIndex.value;

    switch (categoryIndex) {
      case 1:
        result = result.where(
              (ChatModel chat) {
            return chat.unread > 0;
          },
        );
        break;

      case 2:
        result = result.where(
              (ChatModel chat) {
            return chat.type == 'personal';
          },
        );
        break;

      case 3:
        result = result.where(
              (ChatModel chat) {
            return chat.type == 'group';
          },
        );
        break;

      default:
        break;
    }

    String query =
    searchQuery.value.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where(
            (ChatModel chat) {
          bool matchesName = chat.name
              .toLowerCase()
              .contains(query);

          bool matchesMessage = chat.message
              .toLowerCase()
              .contains(query);

          return matchesName || matchesMessage;
        },
      );
    }

    return result.toList();
  }

  /// All chats the user has archived, newest first. Feeds both the
  /// collapsed summary row and the Archived Chats screen.
  List<ChatModel> get archivedChats {
    List<ChatModel> result = chats.where(
          (ChatModel chat) {
        return chat.isArchived;
      },
    ).toList();

    result.sort(
          (ChatModel a, ChatModel b) {
        return b.dateTime.compareTo(a.dateTime);
      },
    );

    return result;
  }

  int get archivedChatCount {
    return archivedChats.length;
  }

  int get totalUnreadCount {
    return chats.fold(
      0,
          (
          int total,
          ChatModel chat,
          ) {
        if (chat.isMuted || chat.isArchived) {
          return total;
        }

        return total + chat.unread;
      },
    );
  }

  int get allChatCount {
    return filteredChats.length;
  }

  int get unreadChatCount {
    return filteredChats.where(
          (ChatModel chat) {
        return chat.unread > 0;
      },
    ).length;
  }

  int get personalChatCount {
    return filteredChats.where(
          (ChatModel chat) {
        return chat.type == 'personal';
      },
    ).length;
  }

  int get groupChatCount {
    return filteredChats.where(
          (ChatModel chat) {
        return chat.type == 'group';
      },
    ).length;
  }

  ChatModel? findChatById(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return null;
    }

    return chats[index];
  }

  void togglePin(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return;
    }

    ChatModel currentChat = chats[index];

    chats[index] = currentChat.copyWith(
      isPinned: !currentChat.isPinned,
    );

    _sortChats();
  }

  void toggleMute(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return;
    }

    ChatModel currentChat = chats[index];

    chats[index] = currentChat.copyWith(
      isMuted: !currentChat.isMuted,
    );
  }

  /// Archives a chat (Telegram-style swipe action on the main list).
  /// The chat disappears from [filteredChats] and [searchResults] and
  /// starts showing up in [archivedChats] instead.
  void archiveChat(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return;
    }

    chats[index] = chats[index].copyWith(
      isArchived: true,
    );
  }

  /// Moves a chat back out of the archive onto the main list.
  void unarchiveChat(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return;
    }

    chats[index] = chats[index].copyWith(
      isArchived: false,
    );
  }

  /// Toggles archive state, handy for a single swipe/menu action that
  /// should work whether the chat currently is or isn't archived.
  void toggleArchive(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return;
    }

    ChatModel currentChat = chats[index];

    chats[index] = currentChat.copyWith(
      isArchived: !currentChat.isArchived,
    );
  }

  /// Replaces a chat in the source list with an already-updated
  /// instance. Used by screens (like ArchivedChatsScreen) that build
  /// their own copyWith() result and just need it written back.
  void updateChat(ChatModel updatedChat) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == updatedChat.id;
      },
    );

    if (index == -1) {
      return;
    }

    chats[index] = updatedChat;
  }

  void markAsRead(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return;
    }

    ChatModel currentChat = chats[index];

    if (currentChat.unread == 0) {
      return;
    }

    chats[index] = currentChat.copyWith(
      unread: 0,
    );
  }

  void markAsUnread(String chatId) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index == -1) {
      return;
    }

    ChatModel currentChat = chats[index];

    chats[index] = currentChat.copyWith(
      unread: currentChat.unread > 0
          ? currentChat.unread
          : 1,
    );
  }

  void markAllAsRead() {
    for (
    int index = 0;
    index < chats.length;
    index++
    ) {
      ChatModel chat = chats[index];

      if (chat.unread > 0) {
        chats[index] = chat.copyWith(
          unread: 0,
        );
      }
    }
  }

  void deleteChat(String chatId) {
    chats.removeWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );
  }

  void clearAllChats() {
    chats.clear();
  }

  void _sortChats() {
    chats.sort(
          (
          ChatModel firstChat,
          ChatModel secondChat,
          ) {
        if (firstChat.isPinned !=
            secondChat.isPinned) {
          return firstChat.isPinned ? -1 : 1;
        }

        return secondChat.dateTime.compareTo(
          firstChat.dateTime,
        );
      },
    );
  }

  void _disposeSearchTextController() {
    TextEditingController? textController =
        _searchTextController;

    if (textController == null) {
      return;
    }

    textController.dispose();
    _searchTextController = null;
  }

  @override
  void onClose() {
    FocusManager.instance.primaryFocus?.unfocus();

    _disposeSearchTextController();

    searchQuery.value = '';
    errorMessage.value = '';
    selectedCategoryIndex.value = 0;
    isSearching.value = false;
    showHomeSearchBar.value = false;

    super.onClose();
  }
}