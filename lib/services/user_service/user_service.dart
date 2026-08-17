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

  LoginDataModel? get currentUserValue =>
      _currentUser.value;

  Stream<LoginDataModel?> get currentUserStream =>
      _currentUser.stream;

  /// GET /auth/me
  Future<LoginDataModel> getProfile() async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.profile,
      token: token,
    );

    final rawData = _extractData(json);

    final user = LoginDataModel.fromJson(rawData);

    _currentUser.value = user;

    return user;
  }

  /// Converts authenticated profile into AppUserModel.
  Future<AppUserModel> getCurrentUser() async {
    final profile = await getProfile();

    return _loginDataToAppUser(profile);
  }

  /// GET /users/{userId}
  Future<AppUserModel> getUserById(
      String userId,
      ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.userById(userId),
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
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.searchUsers(
        search: query.trim(),
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
    final token = await authApiService.requireToken();

    final json = await apiService.patch(
      ApiConstants.userById(userId),
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
    final token = await authApiService.requireToken();

    final json = await apiService.patch(
      ApiConstants.userPresence(userId),
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
    final token = await authApiService.requireToken();

    final json = await apiService.delete(
      ApiConstants.userById(userId),
      body: {
        'password': password,
      },
      token: token,
    );

    _currentUser.value = null;

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
}