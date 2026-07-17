import 'package:appchat/services/user_service.dart';
import '../../models/user_model.dart';
import '../data/mock_chat_database.dart';
import 'mock_service_delay.dart';

class MockAppUserService
    with MockServiceDelay
    implements AppUserService {
  @override
  Future<AppUserModel?>
  getCurrentUser() async {
    await simulateDelay();

    return MockChatDatabase.currentProfile;
  }

  @override
  Future<List<AppUserModel>>
  getUsers() async {
    await simulateDelay();

    return MockChatDatabase.users.toList();
  }

  @override
  Future<AppUserModel?> getUserById(
      String userId,
      ) async {
    await simulateDelay();

    return MockChatDatabase.findUserById(
      userId,
    );
  }

  @override
  Future<List<AppUserModel>> searchUsers(
      String query,
      ) async {
    await simulateDelay();

    String cleanQuery =
    query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      return <AppUserModel>[];
    }

    return MockChatDatabase.users.where(
          (AppUserModel user) {
        return user.name
            .toLowerCase()
            .contains(cleanQuery) ||
            user.username
                .toLowerCase()
                .contains(cleanQuery) ||
            user.phoneNumber
                .toLowerCase()
                .contains(cleanQuery);
      },
    ).toList();
  }
}