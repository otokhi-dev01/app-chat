import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/api_constants.dart';
import '../../data/model/login_response_model.dart';
import '../api_service.dart';

class AuthApiService {
  final ApiService apiService;

  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  static const String _tokenKey = 'access_token';

  AuthApiService({
    required this.apiService,
  });

  Future<LoginResponseModel> login({
    required String login,
    required String password,
  }) async {
    final json = await apiService.post(
      ApiConstants.login,
      body: {
        'login': login.trim(),
        'password': password,
      },
    );

    final response = LoginResponseModel.fromJson(json);

    if (response.accessToken.trim().isNotEmpty) {
      await saveToken(
        response.accessToken,
      );
    }

    return response;
  }

  Future<LoginResponseModel> register({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final json = await apiService.post(
      ApiConstants.register,
      body: {
        'name': name.trim(),
        'phoneNumber': phoneNumber.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'passwordConfirmation':
        passwordConfirmation,
      },
    );

    final response = LoginResponseModel.fromJson(json);

    // Save token if registration automatically logs in.
    if (response.accessToken.trim().isNotEmpty) {
      await saveToken(
        response.accessToken,
      );
    }

    return response;
  }

  Future<LoginResponseModel> verifyLoginOtp({
    required String otpToken,
    required String otp,
  }) async {
    final json = await apiService.post(
      ApiConstants.verifyEmailOtp,
      body: {
        'otp': otp.trim(),
      },
      token: otpToken,
    );

    final response = LoginResponseModel.fromJson(json);

    if (response.accessToken.trim().isNotEmpty) {
      await saveToken(
        response.accessToken,
      );
    }

    return response;
  }

  // ─────────────────────────────────────
  // Token management
  // ─────────────────────────────────────

  Future<void> saveToken(String token) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw const ApiException(
        statusCode: 400,
        message: 'Cannot save an empty token.',
      );
    }

    try {
      await _storage.write(
        key: _tokenKey,
        value: cleanToken,
      );
    } catch (error) {
      debugPrint(
        '[Keychain] Initial token write failed: $error',
      );

      // Handle an existing or corrupted Keychain entry.
      await _storage.delete(
        key: _tokenKey,
      );

      await _storage.write(
        key: _tokenKey,
        value: cleanToken,
      );
    }
  }

  Future<String?> getToken() async {
    final token = await _storage.read(
      key: _tokenKey,
    );

    final cleanToken = token?.trim();

    if (cleanToken == null || cleanToken.isEmpty) {
      return null;
    }

    return cleanToken;
  }

  Future<String> requireToken() async {
    final token = await getToken();

    if (token == null) {
      throw const ApiException(
        statusCode: 401,
        message: 'Session expired.',
      );
    }

    return token;
  }

  Future<bool> hasToken() async {
    return await getToken() != null;
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(
        key: _tokenKey,
      );

      final remainingToken = await _storage.read(
        key: _tokenKey,
      );

      debugPrint(
        '[Auth] Token after deletion: $remainingToken',
      );

      if (remainingToken != null &&
          remainingToken.trim().isNotEmpty) {
        throw StateError(
          'The access token could not be removed.',
        );
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[Auth] Token deletion error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final token = await getToken();

      if (token != null) {
        await apiService.post(
          ApiConstants.logout,
          token: token,
        );
      }
    } catch (error, stackTrace) {
      // Local logout must continue even if the API fails.
      debugPrint(
        '[Auth] Logout API error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    } finally {
      await clearToken();
    }
  }

  Future<Map<String, dynamic>> resendOtp(
      String email,
      ) async {
    return apiService.post(
      ApiConstants.sendEmailOtp,
      body: {
        'email': email.trim().toLowerCase(),
      },
    );
  }
}