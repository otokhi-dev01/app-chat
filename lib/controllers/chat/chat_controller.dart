import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../models/chat_folder_model.dart';
import '../../models/chat_model.dart';
import '../../route/app_route.dart';
import '../../screen/chat_detail/chat_detail_screen.dart';
import '../../screen/home/archived_chat/archived_chat_screen.dart';
import '../../screen/home/search/search_screen.dart';
import '../../services/chat_list_service.dart';

class ChatController extends GetxController {
  final ChatListService chatService;

  ChatController({
    required this.chatService,
  });

  final RxList<ChatModel> chats =
      <ChatModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool showHomeSearchBar = true.obs;

  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;

  // ============================================================
  // CHAT FOLDER FILTER
  // ============================================================

  final RxString selectedFolderId =
      'folder_all'.obs;

  final Rx<ChatFolderType> selectedFolderType =
      ChatFolderType.all.obs;

  final RxList<String> selectedFolderChatIds =
      <String>[].obs;

  TextEditingController? _searchTextController;

  TextEditingController get searchTextController {
    return _searchTextController ??=
        TextEditingController(
          text: searchQuery.value,
        );
  }

  @override
  void onInit() {
    super.onInit();

    loadChats();
  }

  // ============================================================
  // LOAD DATA FROM SERVICE
  // ============================================================

  Future<void> loadChats() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      List<ChatModel> active =
      await chatService.getChats();

      List<ChatModel> archived =
      await chatService.getArchivedChats();

      Map<String, ChatModel> chatMap =
      <String, ChatModel>{};

      for (ChatModel chat in active) {
        chatMap[chat.id] = chat;
      }

      for (ChatModel chat in archived) {
        chatMap[chat.id] = chat;
      }

      chats.assignAll(
        chatMap.values.toList(),
      );

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

  // ============================================================
  // NAVIGATION
  // ============================================================

  Future<void> openSearchScreen() async {
    if (isSearching.value) {
      return;
    }

    isSearching.value = true;

    FocusManager.instance.primaryFocus
        ?.unfocus();

    _disposeSearchTextController();

    _searchTextController =
        TextEditingController(
          text: searchQuery.value,
        );

    _searchTextController!.selection =
        TextSelection.collapsed(
          offset:
          _searchTextController!.text.length,
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
      FocusManager.instance.primaryFocus
          ?.unfocus();

      searchQuery.value = '';

      _disposeSearchTextController();

      isSearching.value = false;
    }
  }

  Future<void>
  openArchivedChatsScreen() async {
    await Get.to(
          () => ArchivedChatsScreen(
        archivedChats: archivedChats,
        onUnarchive: (ChatModel chat) {
          if (chat.isArchived) {
            archiveChat(chat.id);
          } else {
            unarchiveChat(chat.id);
          }
        },
        onDelete: (ChatModel chat) {
          deleteChat(chat.id);
        },
        onToggleMute: (ChatModel chat) {
          toggleMute(chat.id);
        },
        onOpenChat: (ChatModel chat) {
          Get.to(
                () => ChatDetailScreen(
              chat: chat,
            ),
            transition:
            Transition.cupertino,
            duration: Duration(
              milliseconds: 280,
            ),
          );
        },
      ),
      transition: Transition.fadeIn,
      duration: Duration(
        milliseconds: 220,
      ),
    );

    await loadChats();
  }

  Future<void> openSettingsScreen() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    await Get.toNamed(
      AppRoutes.settings,
      preventDuplicates: true,
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void updateSearch(
      String value,
      ) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchQuery.value = '';

    TextEditingController? controller =
        _searchTextController;

    if (controller != null &&
        controller.text.isNotEmpty) {
      controller.clear();
    }
  }

  List<ChatModel> get searchResults {
    return searchAllChats(
      searchQuery.value,
    );
  }

  List<ChatModel> searchAllChats(
      String value,
      ) {
    String query =
    value.trim().toLowerCase();

    if (query.isEmpty) {
      return <ChatModel>[];
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

        return matchesName ||
            matchesMessage;
      },
    ).toList();
  }

  // ============================================================
  // CHAT FOLDER FILTER
  // ============================================================

  void selectFolder(
      ChatFolderModel folder,
      ) {
    if (selectedFolderId.value ==
        folder.id) {
      return;
    }

    selectedFolderId.value = folder.id;
    selectedFolderType.value =
        folder.type;

    selectedFolderChatIds.assignAll(
      folder.chatIds,
    );
  }

  void resetFolderSelection() {
    selectedFolderId.value =
    'folder_all';

    selectedFolderType.value =
        ChatFolderType.all;

    selectedFolderChatIds.clear();
  }

  void synchronizeSelectedFolder(
      List<ChatFolderModel> folders,
      ) {
    if (folders.isEmpty) {
      resetFolderSelection();
      return;
    }

    int selectedIndex =
    folders.indexWhere(
          (ChatFolderModel folder) {
        return folder.id ==
            selectedFolderId.value;
      },
    );

    if (selectedIndex < 0) {
      resetFolderSelection();
      return;
    }

    ChatFolderModel selectedFolder =
    folders[selectedIndex];

    selectedFolderType.value =
        selectedFolder.type;

    selectedFolderChatIds.assignAll(
      selectedFolder.chatIds,
    );
  }

  bool isFolderSelected(
      ChatFolderModel folder,
      ) {
    return selectedFolderId.value ==
        folder.id;
  }

  List<ChatModel> get activeChats {
    return chats.where(
          (ChatModel chat) {
        return !chat.isArchived;
      },
    ).toList();
  }

  List<ChatModel> getChatsForFolder(
      ChatFolderModel folder,
      ) {
    List<ChatModel> result =
        activeChats;

    switch (folder.type) {
      case ChatFolderType.all:
        return result;

      case ChatFolderType.unread:
        return result.where(
              (ChatModel chat) {
            return chat.unread > 0;
          },
        ).toList();

      case ChatFolderType.personal:
        return result.where(
              (ChatModel chat) {
            return chat.type ==
                'personal';
          },
        ).toList();

      case ChatFolderType.groups:
        return result.where(
              (ChatModel chat) {
            return chat.type == 'group';
          },
        ).toList();

      case ChatFolderType.custom:
        if (folder.chatIds.isEmpty) {
          return <ChatModel>[];
        }

        Set<String> folderChatIds =
        folder.chatIds.toSet();

        return result.where(
              (ChatModel chat) {
            return folderChatIds.contains(
              chat.id,
            );
          },
        ).toList();
    }
  }

  int getFolderCount(
      ChatFolderModel folder,
      ) {
    return getChatsForFolder(
      folder,
    ).length;
  }

  List<ChatModel> get folderFilteredChats {
    List<ChatModel> result =
        activeChats;

    ChatFolderType folderType =
        selectedFolderType.value;

    switch (folderType) {
      case ChatFolderType.all:
        return result;

      case ChatFolderType.unread:
        return result.where(
              (ChatModel chat) {
            return chat.unread > 0;
          },
        ).toList();

      case ChatFolderType.personal:
        return result.where(
              (ChatModel chat) {
            return chat.type ==
                'personal';
          },
        ).toList();

      case ChatFolderType.groups:
        return result.where(
              (ChatModel chat) {
            return chat.type == 'group';
          },
        ).toList();

      case ChatFolderType.custom:
        if (selectedFolderChatIds
            .isEmpty) {
          return <ChatModel>[];
        }

        Set<String> folderChatIds =
        selectedFolderChatIds.toSet();

        return result.where(
              (ChatModel chat) {
            return folderChatIds.contains(
              chat.id,
            );
          },
        ).toList();
    }
  }

  List<ChatModel> get filteredChats {
    List<ChatModel> result =
        folderFilteredChats;

    String query = searchQuery.value
        .trim()
        .toLowerCase();

    if (query.isEmpty) {
      return result;
    }

    return result.where(
          (ChatModel chat) {
        bool matchesName = chat.name
            .toLowerCase()
            .contains(query);

        bool matchesMessage = chat.message
            .toLowerCase()
            .contains(query);

        return matchesName ||
            matchesMessage;
      },
    ).toList();
  }

  // ============================================================
  // ARCHIVED CHATS
  // ============================================================

  List<ChatModel> get archivedChats {
    List<ChatModel> result =
    chats.where(
          (ChatModel chat) {
        return chat.isArchived;
      },
    ).toList();

    result.sort(
          (
          ChatModel first,
          ChatModel second,
          ) {
        return second.dateTime.compareTo(
          first.dateTime,
        );
      },
    );

    return result;
  }

  int get archivedChatCount {
    return archivedChats.length;
  }

  // ============================================================
  // COUNTS
  // ============================================================

  int get totalUnreadCount {
    return activeChats.fold(
      0,
          (
          int total,
          ChatModel chat,
          ) {
        if (chat.isMuted) {
          return total;
        }

        return total + chat.unread;
      },
    );
  }

  int get allChatCount {
    return activeChats.length;
  }

  int get unreadChatCount {
    return activeChats.where(
          (ChatModel chat) {
        return chat.unread > 0;
      },
    ).length;
  }

  int get personalChatCount {
    return activeChats.where(
          (ChatModel chat) {
        return chat.type ==
            'personal';
      },
    ).length;
  }

  int get groupChatCount {
    return activeChats.where(
          (ChatModel chat) {
        return chat.type == 'group';
      },
    ).length;
  }

  int get workChatCount {
    return activeChats.where(
          (ChatModel chat) {
        return chat.type == 'work';
      },
    ).length;
  }

  int get onlineChatCount {
    return activeChats.where(
          (ChatModel chat) {
        return chat.isOnline;
      },
    ).length;
  }

  int get offlineChatCount {
    return activeChats.where(
          (ChatModel chat) {
        return !chat.isOnline;
      },
    ).length;
  }

  // ============================================================
  // FIND CHAT
  // ============================================================

  ChatModel? findChatById(
      String chatId,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return null;
    }

    return chats[index];
  }

  // ============================================================
  // PIN / MUTE
  // ============================================================

  Future<void> togglePin(
      String chatId,
      ) async {
    try {
      errorMessage.value = '';

      ChatModel? updated =
      await chatService.togglePinned(
        chatId,
      );

      if (updated == null) {
        return;
      }

      _replaceChat(updated);
      _sortChats();
    } catch (error) {
      errorMessage.value =
      'Failed to update pin: $error';
    }
  }

  Future<void> toggleMute(
      String chatId,
      ) async {
    try {
      errorMessage.value = '';

      ChatModel? updated =
      await chatService.toggleMuted(
        chatId,
      );

      if (updated == null) {
        return;
      }

      _replaceChat(updated);
    } catch (error) {
      errorMessage.value =
      'Failed to update mute: $error';
    }
  }

  // ============================================================
  // ARCHIVE / UNARCHIVE
  // ============================================================

  Future<void> archiveChat(
      String chatId,
      ) async {
    try {
      errorMessage.value = '';

      await chatService.archiveChat(
        chatId,
      );

      _updateLocalChat(
        chatId,
            (ChatModel chat) {
          return chat.copyWith(
            isArchived: true,
          );
        },
      );
    } catch (error) {
      errorMessage.value =
      'Failed to archive chat: $error';
    }
  }

  Future<void> unarchiveChat(
      String chatId,
      ) async {
    try {
      errorMessage.value = '';

      await chatService.unarchiveChat(
        chatId,
      );

      _updateLocalChat(
        chatId,
            (ChatModel chat) {
          return chat.copyWith(
            isArchived: false,
          );
        },
      );

      _sortChats();
    } catch (error) {
      errorMessage.value =
      'Failed to unarchive chat: $error';
    }
  }

  Future<void> toggleArchive(
      String chatId,
      ) async {
    ChatModel? chat =
    findChatById(chatId);

    if (chat == null) {
      return;
    }

    if (chat.isArchived) {
      await unarchiveChat(chatId);
    } else {
      await archiveChat(chatId);
    }
  }

  // ============================================================
  // READ / UNREAD
  // ============================================================

  Future<void> markAsRead(
      String chatId,
      ) async {
    ChatModel? currentChat =
    findChatById(chatId);

    if (currentChat == null ||
        currentChat.unread == 0) {
      return;
    }

    try {
      errorMessage.value = '';

      await chatService.markChatRead(
        chatId,
      );

      _updateLocalChat(
        chatId,
            (ChatModel chat) {
          return chat.copyWith(
            unread: 0,
          );
        },
      );
    } catch (error) {
      errorMessage.value =
      'Failed to mark chat as read: $error';
    }
  }

  Future<void> markAsUnread(
      String chatId,
      ) async {
    try {
      errorMessage.value = '';

      ChatModel? updated =
      await chatService.markChatUnread(
        chatId,
      );

      if (updated == null) {
        return;
      }

      _replaceChat(updated);
    } catch (error) {
      errorMessage.value =
      'Failed to mark chat as unread: $error';
    }
  }

  Future<void> markAllAsRead() async {
    try {
      errorMessage.value = '';

      await chatService.markAllChatsRead();

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

      chats.refresh();
    } catch (error) {
      errorMessage.value =
      'Failed to mark all chats as read: $error';
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deleteChat(
      String chatId,
      ) async {
    try {
      errorMessage.value = '';

      await chatService.deleteChat(
        chatId,
      );

      chats.removeWhere(
            (ChatModel chat) {
          return chat.id == chatId;
        },
      );

      selectedFolderChatIds.remove(
        chatId,
      );
    } catch (error) {
      errorMessage.value =
      'Failed to delete chat: $error';
    }
  }

  Future<void> clearAllChats() async {
    try {
      errorMessage.value = '';

      await chatService.clearChats();

      chats.clear();

      selectedFolderChatIds.clear();
    } catch (error) {
      errorMessage.value =
      'Failed to clear chats: $error';
    }
  }

  // ============================================================
  // UPDATE LOCAL CHAT
  // ============================================================

  void updateChat(
      ChatModel updatedChat,
      ) {
    _replaceChat(updatedChat);
  }

  void _replaceChat(
      ChatModel updatedChat,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id ==
            updatedChat.id;
      },
    );

    if (index < 0) {
      chats.add(updatedChat);
      _sortChats();
      return;
    }

    chats[index] = updatedChat;
    chats.refresh();
  }

  void _updateLocalChat(
      String chatId,
      ChatModel Function(
          ChatModel chat,
          ) updater,
      ) {
    int index = chats.indexWhere(
          (ChatModel chat) {
        return chat.id == chatId;
      },
    );

    if (index < 0) {
      return;
    }

    chats[index] = updater(
      chats[index],
    );

    chats.refresh();
  }

  // ============================================================
  // HOME SEARCH BAR SCROLL
  // ============================================================

  void handleChatScroll(
      UserScrollNotification notification,
      ) {
    if (notification.depth != 0) {
      return;
    }

    double offset =
        notification.metrics.pixels;

    if (offset <= 5) {
      showHomeSearchBar.value = false;
      return;
    }

    if (notification.direction ==
        ScrollDirection.reverse) {
      if (!showHomeSearchBar.value) {
        showHomeSearchBar.value = true;
      }

      return;
    }

    if (notification.direction ==
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

  // ============================================================
  // SORT
  // ============================================================

  void _sortChats() {
    chats.sort(
          (
          ChatModel first,
          ChatModel second,
          ) {
        if (first.isArchived !=
            second.isArchived) {
          return first.isArchived ? 1 : -1;
        }

        if (first.isPinned !=
            second.isPinned) {
          return first.isPinned ? -1 : 1;
        }

        return second.dateTime.compareTo(
          first.dateTime,
        );
      },
    );

    chats.refresh();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  void _disposeSearchTextController() {
    TextEditingController? controller =
        _searchTextController;

    if (controller == null) {
      return;
    }

    controller.dispose();
    _searchTextController = null;
  }

  @override
  void onClose() {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    _disposeSearchTextController();

    searchQuery.value = '';
    errorMessage.value = '';

    resetFolderSelection();

    isSearching.value = false;
    showHomeSearchBar.value = false;

    super.onClose();
  }
}