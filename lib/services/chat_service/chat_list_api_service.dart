import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';
import '../massage_service /chat_list_service.dart';

class ChatListApiService extends GetxService
    implements ChatListService {
  final ApiService apiService;
  final AuthApiService authApiService;

  ChatListApiService({
    required this.apiService,
    required this.authApiService,
  });

  // ── Helpers ──────────────────────────────────────────────

  Future<String> get _token =>
      authApiService.requireToken();

  Future<Map<String, dynamic>> _get(
    String endpoint,
  ) async {
    return apiService.get(
      endpoint,
      token: await _token,
    );
  }

  Future<Map<String, dynamic>> _post(
    String endpoint, {
    Map<String, dynamic> body = const {},
  }) async {
    return apiService.post(
      endpoint,
      body: body,
      token: await _token,
    );
  }

  Future<Map<String, dynamic>> _patch(
    String endpoint, {
    Map<String, dynamic> body = const {},
  }) async {
    return apiService.patch(
      endpoint,
      body: body,
      token: await _token,
    );
  }

  Future<Map<String, dynamic>> _delete(
    String endpoint,
  ) async {
    return apiService.delete(
      endpoint,
      token: await _token,
    );
  }

  List<ChatModel> _parseChatList(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    if (data is! List) return <ChatModel>[];

    return data
        .whereType<Map>()
        .map(
          (item) => ChatModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  ChatModel _parseSingleChat(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] ?? json;

    return ChatModel.fromJson(
      Map<String, dynamic>.from(data as Map),
    );
  }

  // ── ChatListService interface ─────────────────────────────

  @override
  Future<List<ChatModel>> getChats() async {
    final json = await _get(ApiConstants.chats);
    return _parseChatList(json);
  }

  @override
  Future<List<ChatModel>> getArchivedChats() async {
    // The backend returns archived chats mixed in the
    // main list (isArchived flag). We filter here.
    final json = await _get(ApiConstants.chats);
    return _parseChatList(json)
        .where((c) => c.isArchived)
        .toList();
  }

  @override
  Future<ChatModel?> getChatById(
    String chatId,
  ) async {
    try {
      final json = await _get(
        ApiConstants.chatById(chatId),
      );
      return _parseSingleChat(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<AppUserModel>> getChatMembers(
    String chatId,
  ) async {
    // Members are embedded in the chat data.
    final chat = await getChatById(chatId);
    if (chat == null) return <AppUserModel>[];
    // Return empty — member detail screen can load separately.
    return <AppUserModel>[];
  }

  @override
  Future<void> markChatRead(String chatId) async {
    await _post(ApiConstants.chatMarkRead(chatId));
  }

  @override
  Future<ChatModel?> markChatUnread(
    String chatId,
  ) async {
    // Mark-unread toggles the pinned field via preferences
    // until a dedicated endpoint exists.
    try {
      final json = await _patch(
        ApiConstants.chatPreferences(chatId),
        body: {'isUnread': true},
      );
      return _parseSingleChat(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> markAllChatsRead() async {
    // No bulk endpoint yet — no-op to avoid errors.
  }

  @override
  Future<void> archiveChat(String chatId) async {
    await _patch(
      ApiConstants.chatPreferences(chatId),
      body: {'isArchived': true},
    );
  }

  @override
  Future<void> unarchiveChat(String chatId) async {
    await _patch(
      ApiConstants.chatPreferences(chatId),
      body: {'isArchived': false},
    );
  }

  @override
  Future<ChatModel?> togglePinned(
    String chatId,
  ) async {
    final current = await getChatById(chatId);
    if (current == null) return null;

    final json = await _patch(
      ApiConstants.chatPreferences(chatId),
      body: {'isPinned': !current.isPinned},
    );
    return _parseSingleChat(json);
  }

  @override
  Future<ChatModel?> toggleMuted(
    String chatId,
  ) async {
    final current = await getChatById(chatId);
    if (current == null) return null;

    final json = await _patch(
      ApiConstants.chatPreferences(chatId),
      body: {'isMuted': !current.isMuted},
    );
    return _parseSingleChat(json);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _delete(
      ApiConstants.chatById(chatId),
    );
  }

  @override
  Future<void> clearChats() async {
    // No bulk endpoint yet — no-op.
  }

  Future<ChatModel> createDirectChat(String memberId) async {
    final json = await _post(
      ApiConstants.chats + '/direct',
      body: {'memberId': memberId},
    );
    return _parseSingleChat(json);
  }
}
