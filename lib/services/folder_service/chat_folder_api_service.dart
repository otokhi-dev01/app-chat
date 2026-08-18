import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../data/model/chat_folder_member_model.dart';
import '../../models/chat_folder_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';
import '../user_service/user_service.dart';

class ChatFolderApiService extends GetxService {
  final ApiService apiService;
  final AuthApiService authApiService;
  final UserApiService userApiService;

  ChatFolderApiService({
    required this.apiService,
    required this.authApiService,
    required this.userApiService,
  });

  final RxList<ChatFolderModel> folders =
      <ChatFolderModel>[].obs;

  Future<List<ChatFolderModel>> getFolders() async {
    final token = await authApiService.requireToken();
    final userId = userApiService.currentUserValue?.id ?? '';
    final String endpoint = userId.isNotEmpty 
        ? '${ApiConstants.chatFolders}?user_id=$userId' 
        : ApiConstants.chatFolders;

    final json = await apiService.get(
      endpoint,
      token: token,
    );

    final data = _extractList(json);

    final List<ChatFolderModel> result = data
        .whereType<Map>()
        .map(
          (item) => ChatFolderModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();

    folders.assignAll(result);

    return result;
  }

  Future<ChatFolderModel> getFolder(
      String folderId,
      ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.chatFolderById(folderId),
      token: token,
    );

    return ChatFolderModel.fromJson(
      _extractMap(json),
    );
  }

  Future<List<ChatFolderMemberModel>>
  getMemberOptions({
    String search = '',
  }) async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.chatFolderMembers(
        search: search,
      ),
      token: token,
    );

    final data = _extractList(json);

    return data
        .whereType<Map>()
        .map(
          (item) => ChatFolderMemberModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList()
        .cast<ChatFolderMemberModel>();
  }

  Future<ChatFolderModel> createFolder({
    required String name,
    List<String> chatIds = const [],
    List<String> memberIds = const [],
  }) async {
    final token = await authApiService.requireToken();

    final json = await apiService.post(
      ApiConstants.chatFolders,
      body: {
        'name': name.trim(),
        'type': 'custom',
        'chatIds': chatIds,
        'memberIds': memberIds,
      },
      token: token,
    );

    final folder = ChatFolderModel.fromJson(
      _extractMap(json),
    );

    folders.add(folder);

    return folder;
  }

  Future<ChatFolderModel> updateFolder({
    required String folderId,
    String? name,
    List<String>? chatIds,
    List<String>? memberIds,
  }) async {
    final token = await authApiService.requireToken();

    final body = <String, dynamic>{};

    if (name != null) {
      body['name'] = name.trim();
      body['type'] = 'custom';
    }

    if (chatIds != null) {
      body['chatIds'] = chatIds;
    }

    if (memberIds != null) {
      body['memberIds'] = memberIds;
    }

    if (body.isEmpty) {
      throw ArgumentError(
        'At least one folder field is required.',
      );
    }

    final json = await apiService.patch(
      ApiConstants.chatFolderById(folderId),
      body: body,
      token: token,
    );

    final updatedFolder = ChatFolderModel.fromJson(
      _extractMap(json),
    );

    final index = folders.indexWhere(
          (folder) => folder.id == folderId,
    );

    if (index >= 0) {
      folders[index] = updatedFolder;
    }

    return updatedFolder;
  }

  Future<String> deleteFolder(
      String folderId,
      ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.delete(
      ApiConstants.chatFolderById(folderId),
      token: token,
    );

    folders.removeWhere(
          (folder) => folder.id == folderId,
    );

    return json['message']?.toString() ??
        'Chat folder deleted successfully.';
  }

  List<dynamic> _extractList(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    if (data is! List) {
      throw const FormatException(
        'The server returned an invalid folder list.',
      );
    }

    return data;
  }

  Map<String, dynamic> _extractMap(
      Map<String, dynamic> json,
      ) {
    final data = json['data'] ?? json;

    if (data is! Map) {
      throw const FormatException(
        'The server returned invalid folder data.',
      );
    }

    return Map<String, dynamic>.from(data);
  }
}