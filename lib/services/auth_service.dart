import 'package:get/get.dart';
import '../data/mock_auth_user.dart';

enum AuthServiceError {
  invalidCredentials,
  emailAlreadyExists,
  unknown,
}

class AuthServiceException implements Exception {
  final AuthServiceError error;
  final String message;

  AuthServiceException({
    required this.error,
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}

abstract class AuthService {
  RxList<MockAuthUser> get users;

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
}