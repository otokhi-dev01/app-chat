import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../data/model/login_response_model.dart';
import '../../models/user_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';

class UserApiService extends GetxService {
  final ApiService apiService;
  final AuthApiService authApiService;

  // Reactive user state
  final Rxn<LoginDataModel> _currentUser = Rxn<LoginDataModel>();
  LoginDataModel? get currentUserValue => _currentUser.value;

  UserApiService({
    required this.apiService,
    required this.authApiService,
  });

  /// GET users/me — returns the authenticated user as LoginDataModel
  Future<LoginDataModel> getProfile() async {
    final String token = await authApiService.requireToken();
    final Map<String, dynamic> json = await apiService.get(
      ApiConstants.profile,
      token: token,
    );

    final rawData = json['data'] ?? json;
    final user = LoginDataModel.fromJson(Map<String, dynamic>.from(rawData));

    _currentUser.value = user; // Update local state
    return user;
  }

  /// Returns the current authenticated user as AppUserModel (for QR scanner etc.)
  Future<AppUserModel?> getCurrentUser() async {
    try {
      final profile = await getProfile();
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
    } catch (_) {
      return null;
    }
  }

  /// GET users/{id}
  Future<AppUserModel?> getUserById(String userId) async {
    try {
      final String token = await authApiService.requireToken();
      final Map<String, dynamic> json = await apiService.get(
        '/users/$userId',
        token: token,
      );
      final rawData = json['data'] ?? json;
      return AppUserModel.fromJson(Map<String, dynamic>.from(rawData));
    } catch (_) {
      return null;
    }
  }

  /// GET users?search={query}
  Future<List<AppUserModel>> searchUsers(String query) async {
    try {
      final String token = await authApiService.requireToken();
      final Map<String, dynamic> json = await apiService.get(
        '/users?search=${Uri.encodeComponent(query)}',
        token: token,
      );
      final rawList = json['data'] ?? json['users'] ?? [];
      if (rawList is! List) return [];
      return rawList
          .map((item) => AppUserModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// PATCH users/{user}
  Future<LoginDataModel> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final String token = await authApiService.requireToken();
    final Map<String, dynamic> json = await apiService.patch(
      'users/$userId',
      body: data,
      token: token,
    );

    final rawData = json['data'] ?? json;
    final updatedUser = LoginDataModel.fromJson(Map<String, dynamic>.from(rawData));

    _currentUser.value = updatedUser; // Update local state
    return updatedUser;
  }

  /// PATCH users/{user}/presence
  Future<void> updateUserPresence(String userId, bool isOnline) async {
    final String token = await authApiService.requireToken();
    await apiService.patch(
      'users/$userId/presence',
      body: {'is_online': isOnline},
      token: token,
    );
  }
}