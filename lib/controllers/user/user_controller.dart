import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../services/user_service/user_service.dart';

class UserController extends GetxController {
  final UserApiService userApiService;

  UserController({
    required this.userApiService,
  });

  final Rxn<AppUserModel> user =
  Rxn<AppUserModel>();

  final RxList<AppUserModel> searchResults =
      <AppUserModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isFollowing = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  final RxString searchText = ''.obs;

  // These fields keep compatibility with your existing UI.
  final RxString name = ''.obs;
  final RxString status = 'Offline'.obs;
  final RxString phoneNumber = ''.obs;
  final RxString username = ''.obs;
  final RxString bio = ''.obs;
  final RxString profileImageUrl = ''.obs;

  Worker? _searchWorker;
  String? _userId;

  AppUserModel? get currentUser => user.value;

  bool get hasUser => user.value != null;

  @override
  void onInit() {
    super.onInit();

    _userId = _readUserIdFromRoute();

    _searchWorker = debounce<String>(
      searchText,
          (query) {
        searchUsers(query);
      },
      time: const Duration(milliseconds: 500),
    );

    loadUser(userId: _userId);
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    super.onClose();
  }

  /// If userId is null, load the authenticated profile.
  /// If userId exists, load that user's public profile.
  Future<void> loadUser({
    String? userId,
  }) async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final AppUserModel result;

      if (userId == null || userId.trim().isEmpty) {
        result = await userApiService.getCurrentUser();
      } else {
        result = await userApiService.getUserById(
          userId,
        );
      }

      _setUser(result);
    } catch (error) {
      errorMessage.value = _errorText(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUser() async {
    await loadUser(userId: _userId);
  }

  void onSearchChanged(String value) {
    searchText.value = value.trim();
  }

  Future<void> searchUsers(
      String query,
      ) async {
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isSearching.value = true;
      errorMessage.value = '';

      final results = await userApiService.searchUsers(
        query: normalizedQuery,
      );

      searchResults.assignAll(results);
    } catch (error) {
      searchResults.clear();
      errorMessage.value = _errorText(error);
    } finally {
      isSearching.value = false;
    }
  }

  Future<bool> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    final current = user.value;

    if (current == null) {
      errorMessage.value =
      'User information is unavailable.';
      return false;
    }

    if (isUpdating.value) {
      return false;
    }

    try {
      isUpdating.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final updatedProfile =
      await userApiService.updateProfile(
        userId: current.id.toString(),
        data: data,
      );

      final updatedUser = AppUserModel(
        id: updatedProfile.id,
        username: updatedProfile.username,
        name: updatedProfile.name,
        phoneNumber: updatedProfile.phoneNumber,
        email: updatedProfile.email,
        avatarUrl: updatedProfile.avatarUrl,
        bio: updatedProfile.bio,
        isOnline: current.isOnline,
      );

      _setUser(updatedUser);

      successMessage.value =
      'Profile updated successfully.';

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> updatePresence(
      bool isOnline,
      ) async {
    final current = user.value;

    if (current == null) {
      errorMessage.value =
      'User information is unavailable.';
      return false;
    }

    try {
      errorMessage.value = '';

      final updatedUser =
      await userApiService.updateUserPresence(
        userId: current.id.toString(),
        isOnline: isOnline,
      );

      _setUser(updatedUser);

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    }
  }

  Future<bool> deleteAccount({
    required String password,
  }) async {
    final current = user.value;

    if (current == null) {
      errorMessage.value =
      'User information is unavailable.';
      return false;
    }

    if (password.trim().isEmpty) {
      errorMessage.value =
      'Please enter your password.';
      return false;
    }

    if (isDeleting.value) {
      return false;
    }

    try {
      isDeleting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final message =
      await userApiService.deleteAccount(
        userId: current.id.toString(),
        password: password,
      );

      user.value = null;
      _clearDisplayFields();

      successMessage.value = message;

      return true;
    } catch (error) {
      errorMessage.value = _errorText(error);
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  void toggleFollow() {
    isFollowing.toggle();
  }

  void clearSearch() {
    searchText.value = '';
    searchResults.clear();
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  void _setUser(
      AppUserModel value,
      ) {
    user.value = value;

    name.value = value.name;
    username.value = _formatUsername(
      value.username,
    );
    phoneNumber.value = value.phoneNumber;
    bio.value = value.bio;
    profileImageUrl.value = value.avatarUrl;
    status.value = value.isOnline
        ? 'Online'
        : 'Offline';
  }

  void _clearDisplayFields() {
    name.value = '';
    username.value = '';
    phoneNumber.value = '';
    bio.value = '';
    profileImageUrl.value = '';
    status.value = 'Offline';
  }

  String _formatUsername(
      String value,
      ) {
    if (value.isEmpty || value.startsWith('@')) {
      return value;
    }

    return '@$value';
  }

  String? _readUserIdFromRoute() {
    final parameterId = Get.parameters['userId'];

    if (
    parameterId != null &&
        parameterId.trim().isNotEmpty) {
      return parameterId;
    }

    final arguments = Get.arguments;

    if (arguments is String &&
        arguments.trim().isNotEmpty) {
      return arguments;
    }

    if (arguments is Map) {
      final value = arguments['userId'];

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return null;
  }

  String _errorText(
      Object error,
      ) {
    final message = error.toString();

    return message
        .replaceFirst('Exception: ', '')
        .replaceFirst('FormatException: ', '');
  }
}