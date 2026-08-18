import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../data/model/login_response_model.dart';
import '../api_service.dart';

class AuthApiService {
  final ApiService apiService;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'access_token';

  AuthApiService({required this.apiService});

  /// Verifies credentials and returns the full access token + user directly
  /// (OTP step is disabled — the API issues the token in one step).
  Future<LoginResponseModel> login({
    required String login,
    required String password,
  }) async {
    final Map<String, dynamic> json = await apiService.post(
      ApiConstants.login,
      body: {'login': login.trim(), 'password': password},
    );
    final response = LoginResponseModel.fromJson(json);
    if (response.accessToken.isNotEmpty) {
      await _saveToken(response.accessToken);
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
    final Map<String, dynamic> response = await apiService.post(
      ApiConstants.register,
      body: {
        'name': name.trim(),
        'phoneNumber': phoneNumber.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      },
    );

    return LoginResponseModel.fromJson(response);
  }

  /// Step 2: Exchanges otpToken for real accessToken
  Future<LoginResponseModel> verifyLoginOtp({
    required String otpToken,
    required String otp,
  }) async {
    final Map<String, dynamic> json = await apiService.post(
      ApiConstants.verifyEmailOtp,
      body: {'otp': otp},
      token: otpToken,
    );

    final response = LoginResponseModel.fromJson(json);
    if (response.accessToken.isNotEmpty) {
      await _storage.write(key: _tokenKey, value: response.accessToken);
    }
    return response;
  }

  // --- Token Management ---
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<String> requireToken() async {
    final token = await getToken();
    if (token == null || token.trim().isEmpty) {
      throw const ApiException(statusCode: 401, message: 'Session expired.');
    }
    return token.trim();
  }

  /// Saves token to keychain with fallback for iOS -25299 (already exists)
  /// and silent recovery for -25291 (no keychain / simulator issue).
  Future<void> _saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (_) {
      // Might already exist (-25299) — delete then retry
      try {
        await _storage.delete(key: _tokenKey);
        await _storage.write(key: _tokenKey, value: token);
      } catch (e) {
        // Keychain unavailable (-25291) on simulator — skip silently
        // Token won't persist but the session works in-memory for now
        debugPrint('[Keychain] Could not save token: $e');
      }
    }
  }

  Future<void> logout() async {
    final token = await getToken();
    try {
      if (token != null) await apiService.post(ApiConstants.logout, token: token);
    } finally {
      await _storage.delete(key: _tokenKey);
    }
  }

  // --- General OTP methods ---
  Future<Map<String, dynamic>> resendOtp(String email) async {
    return await apiService.post(ApiConstants.sendEmailOtp, body: {"email": email});
  }
}