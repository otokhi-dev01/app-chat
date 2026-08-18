import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../models/chat_message_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';
import '../user_service/user_service.dart';
import 'message_service.dart';

class MessageApiService extends GetxService implements MessageService {
  final ApiService apiService;
  final AuthApiService authApiService;
  final UserApiService userApiService;

  MessageApiService({
    required this.apiService,
    required this.authApiService,
    required this.userApiService,
  });

  Future<String> get _token => authApiService.requireToken();

  Future<Map<String, dynamic>> _get(String endpoint) async {
    return apiService.get(endpoint, token: await _token);
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

  Future<Map<String, dynamic>> _delete(String endpoint) async {
    return apiService.delete(endpoint, token: await _token);
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String chatId) async {
    final json = await _get(ApiConstants.chatMessages(chatId));
    final data = json['data'];

    if (data is! List) return <ChatMessageModel>[];

    final myId = userApiService.currentUserValue?.id ?? '';

    return data
        .whereType<Map>()
        .map((item) {
          final map = Map<String, dynamic>.from(item);
          final message = ChatMessageModel.fromJson(map);
          return message.copyWith(isMe: message.senderId == myId);
        })
        .toList();
  }

  @override
  Future<ChatMessageModel?> getMessageById({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final json = await _get(ApiConstants.chatMessageById(chatId, messageId));
      final data = json['data'] ?? json;
      final myId = userApiService.currentUserValue?.id ?? '';
      
      final message = ChatMessageModel.fromJson(Map<String, dynamic>.from(data as Map));
      return message.copyWith(isMe: message.senderId == myId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ChatMessageModel> sendTextMessage({
    required String chatId,
    required String text,
  }) async {
    final json = await _post(
      ApiConstants.chatMessages(chatId),
      body: {
        'message': text,
        'type': 'text',
      },
    );
    final data = json['data'] ?? json;
    final message = ChatMessageModel.fromJson(Map<String, dynamic>.from(data as Map));
    return message.copyWith(isMe: true);
  }

  @override
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    await _delete(ApiConstants.chatMessageById(chatId, messageId));
  }

  @override
  Future<ChatMessageModel?> markMessageRead({
    required String chatId,
    required String messageId,
  }) async {
    // Currently no dedicated endpoint for marking a specific message as read.
    return null;
  }
}
