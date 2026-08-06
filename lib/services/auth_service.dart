import 'package:get/get.dart';

import '../data/mock_auth_user.dart';

enum AuthServiceError {
  invalidCredentials,
  emailAlreadyExists,
  notAuthenticated,
  deleteFailed,
}

class AuthServiceException implements Exception {
  final AuthServiceError error;
  final String message;

  const AuthServiceException({
    required this.error,
    required this.message,
  });

  @override
  String toString() => message;
}

abstract class AuthService {
  RxList<MockAuthUser> get users;

  Rxn<MockAuthUser> get currentUser;

  Future<MockAuthUser> login({
    required String email,
    required String password,
  });

  Future<MockAuthUser> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> deleteAccount();
}