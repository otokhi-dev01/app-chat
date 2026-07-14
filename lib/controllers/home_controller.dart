// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import '../models/home_model.dart';
// import '../screen/search/search_screen.dart';
//
// class HomeController extends GetxController {
//   final chats = <ChatModel>[
//     ChatModel(
//       name: 'John',
//       message: 'Hello, how are you?',
//       time: '10:30',
//       image: 'https://i.pravatar.cc/150?img=1',
//       unread: 2,
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Sarah',
//       message: 'See you tomorrow',
//       time: '09:15',
//       image: 'https://i.pravatar.cc/150?img=2',
//       type: 'personal',
//     ),
//     ChatModel(
//       name: 'Flutter Group',
//       message: 'Photo',
//       time: 'Yesterday',
//       image: 'https://i.pravatar.cc/150?img=3',
//       unread: 5,
//       type: 'group',
//     ),
//   ].obs;
//
//   final selectedCategoryIndex = 0.obs;
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//
//   final categories = const [
//     'All',
//     'Unread',
//     'Personal',
//     'Groups',
//   ];
//
//   // ---- Search & scroll state (drives HomeAppBar) ----
//
//   /// True once the user has scrolled the chat list down, or tapped the
//   /// search icon manually. HomeAppBar swaps the category filter for a
//   /// search field when this is true.
//   final RxBool isSearching = false.obs;
//
//   final TextEditingController searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;
//
//   /// Attach this to the chat list's ListView(controller: ...) so scrolling
//   /// down automatically reveals the search field.
//   final ScrollController chatScrollController = ScrollController();
//
//   double _lastOffset = 0;
//
//   @override
//   void onInit() {
//     super.onInit();
//     chatScrollController.addListener(_handleScroll);
//   }
//
//   /// Direction-based reveal: scrolling down opens the search bar,
//   /// scrolling up closes it — regardless of absolute scroll position.
//   void _handleScroll() {
//     if (!chatScrollController.hasClients) return;
//
//     final double offset = chatScrollController.offset;
//     final double delta = offset - _lastOffset;
//
//     if (offset <= 0) {
//       // Always closed once back at the very top.
//       isSearching.value = false;
//     } else if (delta > 2 && !isSearching.value) {
//       isSearching.value = true;
//     } else if (delta < -2 && isSearching.value) {
//       isSearching.value = false;
//     }
//
//     _lastOffset = offset;
//   }
//
//   /// Opens the dedicated full-screen search experience.
//   void openSearchScreen() {
//     Get.to(() => SearchScreen());
//   }
//
//   void selectCategory(int index) {
//     selectedCategoryIndex.value = index;
//   }
//
//   List<ChatModel> get filteredChats {
//     Iterable<ChatModel> result;
//
//     switch (selectedCategoryIndex.value) {
//       case 1:
//         result = chats.where((chat) => chat.unread > 0);
//         break;
//
//       case 2:
//         result = chats.where((chat) => chat.type == 'personal');
//         break;
//
//       case 3:
//         result = chats.where((chat) => chat.type == 'group');
//         break;
//
//       default:
//         result = chats;
//     }
//
//     final String query = searchQuery.value.trim().toLowerCase();
//
//     if (query.isNotEmpty) {
//       result = result.where(
//             (chat) =>
//         chat.name.toLowerCase().contains(query) ||
//             chat.message.toLowerCase().contains(query),
//       );
//     }
//
//     return result.toList();
//   }
//
//   /// Searches ALL chats regardless of the selected category tab.
//   /// Used by the dedicated SearchScreen.
//   List<ChatModel> searchAllChats(String query) {
//     final String q = query.trim().toLowerCase();
//     if (q.isEmpty) return [];
//
//     return chats
//         .where(
//           (chat) =>
//       chat.name.toLowerCase().contains(q) ||
//           chat.message.toLowerCase().contains(q),
//     )
//         .toList();
//   }
//
//   int categoryCount(int index) {
//     switch (index) {
//       case 1:
//         return chats
//             .where((chat) => chat.unread > 0)
//             .length;
//
//       case 2:
//         return chats
//             .where((chat) => chat.type == 'personal')
//             .length;
//
//       case 3:
//         return chats
//             .where((chat) => chat.type == 'group')
//             .length;
//
//       default:
//         return chats.length;
//     }
//   }
//
//   Future<void> refreshChats() async {
//     errorMessage.value = '';
//
//     chats.refresh();
//   }
//
//   void retry() {
//     errorMessage.value = '';
//
//     chats.refresh();
//   }
//
//   @override
//   void onClose() {
//     chatScrollController.removeListener(_handleScroll);
//     chatScrollController.dispose();
//     searchController.dispose();
//     super.onClose();
//   }
// }