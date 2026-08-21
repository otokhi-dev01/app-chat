import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../services/search_service/search_history_service.dart';
import '../../services/contact_service/contact_api_service.dart';
import '../../services/chat_service/chat_list_api_service.dart';
import '../../models/chat_model.dart';
import '../../models/contact_model.dart';

enum SearchScope {
  chats,
  contacts,
  all,
}

class ChatSearchController extends GetxController {
  final ContactApiService contactApiService;
  final ChatListApiService chatListApiService;

  ChatSearchController({
    required this.contactApiService,
    required this.chatListApiService,
  });

  final SearchHistoryService historyService =
  SearchHistoryService();

  final TextEditingController searchTextController =
  TextEditingController();

  final RxString searchQuery = ''.obs;

  final RxList<String> searchHistory =
      <String>[].obs;

  final RxList<VisitedUser> visitedUsers =
      <VisitedUser>[].obs;

  final RxList<ChatModel> searchResults =
      <ChatModel>[].obs;

  final Rx<SearchScope> selectedScope =
      SearchScope.chats.obs;

  // Optional alias if you already use searchController elsewhere.
  TextEditingController get searchController {
    return searchTextController;
  }

  @override
  void onInit() {
    super.onInit();
    loadHistory();
    loadVisitedUsers();

    debounce(searchQuery, (String query) {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isNotEmpty) {
        search(trimmedQuery, saveHistory: false);
      } else {
        searchResults.clear();
      }
    }, time: const Duration(milliseconds: 400));
  }

  Future<void> loadHistory() async {
    final List<String> history =
    await historyService.getHistory();

    searchHistory.assignAll(history);
  }

  Future<void> loadVisitedUsers() async {
    final List<VisitedUser> users =
    await historyService.getVisitedUsers();

    visitedUsers.assignAll(users);
  }

  Future<void> addVisitedUser(VisitedUser user) async {
    await historyService.addVisitedUser(user);
    await loadVisitedUsers();
  }

  Future<void> removeVisitedUser(String id) async {
    await historyService.removeVisitedUser(id);
    await loadVisitedUsers();
  }

  Future<void> clearVisitedUsers() async {
    await historyService.clearVisitedUsers();
    visitedUsers.clear();
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  Future<void> addHistory(String value) async {
    final String query = value.trim();
    if (query.isEmpty) {
      return;
    }
    await historyService.addSearch(query);
    await loadHistory();
  }

  Future<void> search(String value, {bool saveHistory = true}) async {
    final String query = value.trim();

    updateSearch(query);

    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    if (saveHistory) {
      await addHistory(query);
    }

    try {
      final List<ContactModel> contacts = await contactApiService.getUserOptions(search: query);
      
      searchResults.assignAll(contacts.map((contact) => ChatModel(
        id: contact.id, // Using user ID as ID temporarily
        peerUserId: contact.id, // Set peerUserId for direct chat creation
        name: contact.name,
        message: contact.username, // Show username as message
        dateTime: DateTime.now(),
        type: 'personal',
        image: contact.avatarUrl,
        isOnline: contact.isOnline,
      )).toList());
    } catch (e) {
      searchResults.clear();
    }
  }

  Future<void> selectHistory(String value) async {
    final String query = value.trim();
    searchTextController.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(
        offset: query.length,
      ),
    );

    updateSearch(query);

    if (query.isNotEmpty) {
      await addHistory(query);
    }
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }

  Future<void> removeHistory(String value) async {
    await historyService.removeSearch(value);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await historyService.clearHistory();
    searchHistory.clear();
  }

  void changeScope(SearchScope scope) {
    selectedScope.value = scope;
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}