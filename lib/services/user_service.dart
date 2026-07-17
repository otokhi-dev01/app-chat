import '../../models/user_model.dart';

abstract class AppUserService {
  Future<AppUserModel?> getCurrentUser();

  Future<List<AppUserModel>> getUsers();

  Future<AppUserModel?> getUserById(
      String userId,
      );

  Future<List<AppUserModel>> searchUsers(
      String query,
      );
}