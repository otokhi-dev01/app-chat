import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../data/model/login_response_model.dart';
import '../../models/user_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';

class UserApiService extends GetxService {
  final ApiService apiService;
  final AuthApiService authApiService;

  UserApiService({
    required this.apiService,
    required this.authApiService,
  });

  final Rxn<LoginDataModel> _currentUser =
  Rxn<LoginDataModel>();

  LoginDataModel? get currentUserValue {
    return _currentUser.value;
  }

  Stream<LoginDataModel?> get currentUserStream {
    return _currentUser.stream;
  }

  bool get hasCurrentUser {
    return _currentUser.value != null;
  }

  /// GET /auth/me
  Future<LoginDataModel> getProfile({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _currentUser.value != null) {
      return _currentUser.value!;
    }

    final token =
    await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.profile,
      token: token,
    );

    final user = LoginDataModel.fromJson(
      _extractData(json),
    );

    _currentUser.value = user;

    return user;
  }

  Future<AppUserModel> getCurrentUser({
    bool forceRefresh = false,
  }) async {
    final profile = await getProfile(
      forceRefresh: forceRefresh,
    );

    return _loginDataToAppUser(profile);
  }

  /// GET /users/{userId}
  Future<AppUserModel> getUserById(
      String userId,
      ) async {
    final cleanUserId = userId.trim();

    if (cleanUserId.isEmpty) {
      throw const FormatException(
        'User ID is required.',
      );
    }

    final token =
    await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.userById(cleanUserId),
      token: token,
    );

    return AppUserModel.fromJson(
      _extractData(json),
    );
  }

  /// GET /users?search=...
  Future<List<AppUserModel>> searchUsers({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return [];
    }

    final token =
    await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.searchUsers(
        search: cleanQuery,
        page: page,
        perPage: perPage,
      ),
      token: token,
    );

    final rawData = json['data'];

    if (rawData is! List) {
      return [];
    }

    return rawData
        .whereType<Map>()
        .map(
          (item) => AppUserModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  /// PATCH /users/{userId}
  Future<LoginDataModel> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final cleanUserId = userId.trim();

    if (cleanUserId.isEmpty) {
      throw const FormatException(
        'User ID is required.',
      );
    }

    final token =
    await authApiService.requireToken();

    final json = await apiService.patch(
      ApiConstants.userById(cleanUserId),
      body: data,
      token: token,
    );

    final updatedUser = LoginDataModel.fromJson(
      _extractData(json),
    );

    _currentUser.value = updatedUser;

    return updatedUser;
  }

  /// PATCH /users/{userId}/presence
  Future<AppUserModel> updateUserPresence({
    required String userId,
    required bool isOnline,
  }) async {
    final cleanUserId = userId.trim();

    if (cleanUserId.isEmpty) {
      throw const FormatException(
        'User ID is required.',
      );
    }

    final token =
    await authApiService.requireToken();

    final json = await apiService.patch(
      ApiConstants.userPresence(cleanUserId),
      body: {
        'isOnline': isOnline,
      },
      token: token,
    );

    return AppUserModel.fromJson(
      _extractData(json),
    );
  }

  /// DELETE /users/{userId}
  Future<String> deleteAccount({
    required String userId,
    required String password,
  }) async {
    final cleanUserId = userId.trim();

    if (cleanUserId.isEmpty) {
      throw const FormatException(
        'User ID is required.',
      );
    }

    if (password.isEmpty) {
      throw const FormatException(
        'Password is required.',
      );
    }

    final token =
    await authApiService.requireToken();

    final json = await apiService.delete(
      ApiConstants.userById(cleanUserId),
      body: {
        'password': password,
      },
      token: token,
    );

    // Clear user data and token after account deletion.
    clearCurrentUser();
    await authApiService.clearToken();

    return json['message']?.toString() ??
        'Account deleted successfully.';
  }

  Map<String, dynamic> _extractData(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'] ?? json;

    if (rawData is! Map) {
      throw const FormatException(
        'The server returned invalid user data.',
      );
    }

    return Map<String, dynamic>.from(rawData);
  }

  AppUserModel _loginDataToAppUser(
      LoginDataModel profile,
      ) {
    return AppUserModel(
      id: profile.id,
      username: profile.username,
      name: profile.name,
      phoneNumber: profile.phoneNumber,
      email: profile.email,
      avatarUrl: profile.avatarUrl,
      bio: profile.bio,
      isOnline: true,
    );
  }

  void clearCurrentUser() {
    _currentUser.value = null;
  }

  @override
  void onClose() {
    clearCurrentUser();
    super.onClose();
  }
}