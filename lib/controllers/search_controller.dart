// import 'dart:async';
//
// import 'package:get/get.dart';
//
// import '../models/chat_model.dart';
// import '../models/contact_model.dart';
// import 'chat_controller.dart';
//
// enum SearchScope { chats, contacts, all }
//
// class AppSearchController extends GetxController {
//   final ChatController chatController;
//
//   AppSearchController({required this.chatController});
//
//   final RxString query = ''.obs;
//   final RxBool isSearching = false.obs;
//   final Rx<SearchScope> scope = SearchScope.all.obs;
//
//   final RxList<ChatModel> chatResults = <ChatModel>[].obs;
//   final RxList<ContactModel> contactResults = <ContactModel>[].obs;
//
//   final RxList<String> recentSearches = <String>[].obs;
//
//   Timer? _debounce;
//
//   void updateQuery(String value) {
//     query.value = value;
//
//     _debounce?.cancel();
//
//     if (value.trim().isEmpty) {
//       chatResults.clear();
//       contactResults.clear();
//       return;
//     }
//
//     _debounce = Timer(const Duration(milliseconds: 250), () {
//       _runSearch(value.trim());
//     });
//   }
//
//   void _runSearch(String term) {
//     final String lower = term.toLowerCase();
//
//     if (scope.value == SearchScope.chats || scope.value == SearchScope.all) {
//       chatResults.assignAll(
//         chatController.chats.where((ChatModel chat) {
//           return chat.name.toLowerCase().contains(lower) ||
//               chat.lastMessage.toLowerCase().contains(lower);
//         }),
//       );
//     } else {
//       chatResults.clear();
//     }
//
//     if (scope.value == SearchScope.contacts ||
//         scope.value == SearchScope.all) {
//       // TODO: replace with real contacts source (ContactController) once available
//       contactResults.clear();
//     } else {
//       contactResults.clear();
//     }
//   }
//
//   void changeScope(SearchScope newScope) {
//     scope.value = newScope;
//
//     if (query.value.trim().isNotEmpty) {
//       _runSearch(query.value.trim());
//     }
//   }
//
//   void submitSearch(String term) {
//     final String trimmed = term.trim();
//     if (trimmed.isEmpty) return;
//
//     recentSearches.remove(trimmed);
//     recentSearches.insert(0, trimmed);
//
//     if (recentSearches.length > 10) {
//       recentSearches.removeLast();
//     }
//   }
//
//   void removeRecentSearch(String term) {
//     recentSearches.remove(term);
//   }
//
//   void clearRecentSearches() {
//     recentSearches.clear();
//   }
//
//   void clearSearch() {
//     query.value = '';
//     chatResults.clear();
//     contactResults.clear();
//   }
//
//   bool get hasResults => chatResults.isNotEmpty || contactResults.isNotEmpty;
//
//   bool get hasQuery => query.value.trim().isNotEmpty;
//
//   @override
//   void onClose() {
//     _debounce?.cancel();
//     super.onClose();
//   }
// }