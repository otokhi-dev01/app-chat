import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../models/chat_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';

class GroupChatApiService extends GetxService {
  final ApiService apiService;
  final AuthApiService authApiService;

  GroupChatApiService({
    required this.apiService,
    required this.authApiService,
  });

  Future<ChatModel> createGroup({
    required String name,
    required List<String> memberIds,
    File? groupImage,
  }) async {
    final token = await authApiService.requireToken();

    final fields = {
      'name': name,
      'memberIds': jsonEncode(memberIds),
    };

    final files = <String, File>{};
    if (groupImage != null) {
      files['groupImage'] = groupImage;
    }

    final json = await apiService.postMultipart(
      ApiConstants.groupChats,
      fields: fields,
      files: files,
      token: token,
    );

    final data = json['data'] ?? json;

    if (data is! Map) {
      throw const FormatException(
        'The server returned invalid chat data.',
      );
    }

    return ChatModel.fromJson(Map<String, dynamic>.from(data));
  }
}
