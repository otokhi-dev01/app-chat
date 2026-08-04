import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveLoginData({
    required String token,
    required String userId,
  }) async {
    await _storage.write(key: 'access_token', value: token);
    await _storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getToken() {
    return _storage.read(key: 'access_token');
  }

  Future<void> clearLoginData() {
    return _storage.deleteAll();
  }
}