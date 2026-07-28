import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../data/mock_auth_user.dart';
import '../auth_service.dart';

class MockAuthService implements AuthService {
  @override
  final RxList<MockAuthUser> users =
      <MockAuthUser>[
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
  Future<MockAuthUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(
      Duration(
        milliseconds: 900,
      ),
    );

    String normalizedEmail =
    email.trim().toLowerCase();

    for (MockAuthUser user in users) {
      bool emailMatches =
          user.email.toLowerCase() ==
              normalizedEmail;

      bool passwordMatches =
          user.password == password;

      if (emailMatches &&
          passwordMatches) {
        return user;
      }
    }

    throw AuthServiceException(
      error:
      AuthServiceError.invalidCredentials,
      message:
      'The email or password is incorrect.',
    );
  }

  @override
  Future<MockAuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(
      Duration(
        milliseconds: 900,
      ),
    );

    String normalizedEmail =
    email.trim().toLowerCase();

    bool emailAlreadyExists = users.any(
          (MockAuthUser user) {
        return user.email.toLowerCase() ==
            normalizedEmail;
      },
    );

    if (emailAlreadyExists) {
      throw AuthServiceException(
        error:
        AuthServiceError.emailAlreadyExists,
        message:
        'This email is already registered.',
      );
    }

    MockAuthUser newUser =
    MockAuthUser(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      name: name.trim(),
      email: normalizedEmail,
      password: password,
    );

    users.add(
      newUser,
    );

    return newUser;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(
      Duration(
        milliseconds: 100,
      ),
    );
  }
}