// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/search/search_controller.dart';
// import '../../../data/mock_chat_data.dart';
// import '../../../models/chat_model.dart';
// import '../chat_detail/chat_detail_screen.dart';
// import 'search_empty_state.dart';
// import 'search_input_field.dart';
// import 'search_result_tile.dart';
// import 'search_scope_selector.dart';
//
// /// UPDATED: Concise SearchScreen importing modular search components and glassmorphic header
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() {
//     return _SearchScreenState();
//   }
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   late final ChatSearchController controller;
//   late final List<ChatModel> mockChats;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.isRegistered<ChatSearchController>()
//         ? Get.find<ChatSearchController>()
//         : Get.put(ChatSearchController());
//
//     mockChats = MockChatData.build();
//   }
//
//   void _closeSearch(BuildContext context) {
//     FocusManager.instance.primaryFocus?.unfocus();
//     if (Navigator.of(context).canPop()) {
//       Navigator.of(context).pop();
//       return;
//     }
//     Get.back();
//   }
//
//   void _clearSearch() {
//     controller.clearSearch();
//   }
//
//   Future<void> _openChat(ChatModel chat) async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     await Get.to(
//           () => ChatDetailScreen(chat: chat),
//       transition: Transition.cupertino,
//       duration: const Duration(milliseconds: 280),
//     );
//   }
//
//   SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
//     if (isDark) {
//       return SystemUiOverlayStyle.light.copyWith(
//         statusBarColor: Colors.transparent,
//         systemNavigationBarColor: theme.scaffoldBackgroundColor,
//       );
//     }
//     return SystemUiOverlayStyle.dark.copyWith(
//       statusBarColor: Colors.transparent,
//       systemNavigationBarColor: theme.scaffoldBackgroundColor,
//     );
//   }
//
//   List<ChatModel> _getSearchResults() {
//     final String query = controller.searchQuery.value.trim().toLowerCase();
//     final SearchScope scope = controller.selectedScope.value;
//
//     if (query.isEmpty) return <ChatModel>[];
//
//     return mockChats.where((ChatModel chat) {
//       if (chat.isArchived) return false;
//
//       bool scopeMatches = true;
//       if (scope == SearchScope.contacts) {
//         scopeMatches = chat.type == 'personal';
//       }
//       if (scope == SearchScope.chats) {
//         scopeMatches = chat.type == 'personal' ||
//             chat.type == 'group' ||
//             chat.type == 'saved';
//       }
//
//       if (!scopeMatches) return false;
//
//       final String name = chat.name.toLowerCase();
//       final String message = chat.message.toLowerCase();
//       return name.contains(query) || message.contains(query);
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     final ColorScheme colorScheme = theme.colorScheme;
//     final bool isDark = theme.brightness == Brightness.dark;
//     final SystemUiOverlayStyle overlayStyle = _overlayStyle(theme, isDark);
//
//     // FIXED: Calculate top space so body content clears glassmorphic translucent AppBar
//     final double topSpace = MediaQuery.of(context).padding.top + 68;
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: overlayStyle,
//       child: PopScope(
//         onPopInvokedWithResult: (bool didPop, Object? result) {
//           if (didPop) FocusManager.instance.primaryFocus?.unfocus();
//         },
//         child: Scaffold(
//           extendBodyBehindAppBar: true,
//           backgroundColor: theme.scaffoldBackgroundColor,
//           resizeToAvoidBottomInset: true,
//           appBar: _buildAppBar(context, theme, colorScheme, isDark, overlayStyle),
//           body: Padding(
//             padding: EdgeInsets.only(top: topSpace),
//             child: Obx(() => _buildBody(context, theme, colorScheme)),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// ADDED: Glassmorphic AppBar with floating 40x40 back button and search input
//   PreferredSizeWidget _buildAppBar(
//       BuildContext context,
//       ThemeData theme,
//       ColorScheme colorScheme,
//       bool isDark,
//       SystemUiOverlayStyle overlayStyle,
//       ) {
//     final Color headerColor = isDark
//         ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
//         : Colors.white.withValues(alpha: 0.70);
//
//     final Color actionBackground =
//     isDark ? const Color(0xFF1B1D22) : Colors.white;
//
//     final Color borderColor = isDark
//         ? Colors.white.withValues(alpha: 0.08)
//         : Colors.black.withValues(alpha: 0.06);
//
//     return AppBar(
//       toolbarHeight: 68,
//       automaticallyImplyLeading: false,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       titleSpacing: 0,
//       leadingWidth: 58,
//       systemOverlayStyle: overlayStyle,
//       flexibleSpace: ClipRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: headerColor,
//               border: Border(bottom: BorderSide(color: borderColor, width: 1)),
//             ),
//           ),
//         ),
//       ),
//       leading: Padding(
//         padding: const EdgeInsets.fromLTRB(12, 14, 6, 14),
//         child: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: actionBackground,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: borderColor, width: 1),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(
//                   alpha: isDark ? 0.15 : 0.04,
//                 ),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: CupertinoButton(
//             padding: EdgeInsets.zero,
//             onPressed: () => _closeSearch(context),
//             child: Icon(
//               CupertinoIcons.chevron_left,
//               size: 20,
//               color: colorScheme.onSurface,
//             ),
//           ),
//         ),
//       ),
//       title: Padding(
//         padding: const EdgeInsets.only(right: 12),
//         child: SearchInputField(
//           controller: controller,
//           onClear: _clearSearch,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody(
//       BuildContext context,
//       ThemeData theme,
//       ColorScheme colorScheme,
//       ) {
//     final String query = controller.searchQuery.value.trim();
//
//     if (query.isEmpty) {
//       return _buildHistoryView(context, theme, colorScheme);
//     }
//
//     final List<ChatModel> results = _getSearchResults();
//
//     return Column(
//       children: [
//         // REPLACED: Extracted SearchScopeSelector widget
//         SearchScopeSelector(
//           selectedScope: controller.selectedScope.value,
//           onScopeChanged: (SearchScope scope) => controller.changeScope(scope),
//         ),
//         Expanded(
//           child: results.isEmpty
//               ? SearchEmptyState(
//             title: 'no_results_found'.tr,
//             description: 'no_chats_match'.trParams({'query': query}),
//           )
//               : ListView.separated(
//             keyboardDismissBehavior:
//             ScrollViewKeyboardDismissBehavior.onDrag,
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.only(top: 6, bottom: 30),
//             itemCount: results.length,
//             separatorBuilder: (context, index) => Divider(
//               height: 1,
//               indent: 82,
//               endIndent: 14,
//               color: colorScheme.outlineVariant.withValues(alpha: 0.35),
//             ),
//             itemBuilder: (context, index) {
//               return SearchResultTile(
//                 chat: results[index],
//                 onTap: () => _openChat(results[index]),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHistoryView(
//       BuildContext context,
//       ThemeData theme,
//       ColorScheme colorScheme,
//       ) {
//     if (controller.searchHistory.isEmpty) {
//       return SearchEmptyState(
//         title: 'search_chats'.tr,
//         description: 'search_hint_description'.tr,
//       );
//     }
//
//     return ListView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(14, 18, 14, 30),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'recent_searches'.tr,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             TextButton(
//               onPressed: () => controller.clearHistory(),
//               child: Text('clear'.tr),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         ...controller.searchHistory.map((String query) {
//           return ListTile(
//             contentPadding: EdgeInsets.zero,
//             leading: Icon(
//               CupertinoIcons.time,
//               color: colorScheme.onSurfaceVariant,
//             ),
//             title: Text(
//               query,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             onTap: () => controller.selectHistory(query),
//             trailing: IconButton(
//               icon: const Icon(CupertinoIcons.xmark, size: 18),
//               onPressed: () => controller.removeHistory(query),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }