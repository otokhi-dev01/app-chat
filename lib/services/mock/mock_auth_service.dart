import 'package:get/get.dart';

import '../../data/mock_auth_user.dart';
import '../auth_service.dart';

class MockAuthService implements AuthService {
  @override
  final RxList<MockAuthUser> users = <MockAuthUser>[
    MockAuthUser(
      id: '1',
      name: 'Alex Morgan',
      email: 'otokhichat@gmail.com',
      password: 'ch757595',
    ),
    MockAuthUser(
      id: '2',
      name: 'Demo User',
      email: 'demo@appchat.com',
      password: '123456',
    ),
  ].obs;

  @override
  final Rxn<MockAuthUser> currentUser = Rxn<MockAuthUser>();

  @override
  Future<MockAuthUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final String normalizedEmail = email.trim().toLowerCase();

    for (final MockAuthUser user in users) {
      final bool emailMatches = user.email.toLowerCase() == normalizedEmail;
      final bool passwordMatches = user.password == password;

      if (emailMatches && passwordMatches) {
        currentUser.value = user;
        return user;
      }
    }

    throw AuthServiceException(
      error: AuthServiceError.invalidCredentials,
      message: 'The email or password is incorrect.',
    );
  }

  @override
  Future<MockAuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final String normalizedEmail = email.trim().toLowerCase();

    final bool emailAlreadyExists = users.any(
          (MockAuthUser user) => user.email.toLowerCase() == normalizedEmail,
    );

    if (emailAlreadyExists) {
      throw AuthServiceException(
        error: AuthServiceError.emailAlreadyExists,
        message: 'This email is already registered.',
      );
    }

    final MockAuthUser newUser = MockAuthUser(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalizedEmail,
      password: password,
    );

    users.add(newUser);
    currentUser.value = newUser;

    return newUser;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    currentUser.value = null;
  }

  @override
  Future<void> deleteAccount() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final MockAuthUser? signedInUser = currentUser.value;

    if (signedInUser == null) {
      throw AuthServiceException(
        error: AuthServiceError.notAuthenticated,
        message: 'No signed-in account was found.',
      );
    }

    users.removeWhere((MockAuthUser user) => user.id == signedInUser.id);
    currentUser.value = null;
  }
}