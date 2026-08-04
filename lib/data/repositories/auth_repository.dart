import '../model/login_response_model.dart';
import '../providers/auth_api_provider.dart';

class AuthRepository {
  final AuthApiProvider apiProvider;

  AuthRepository(this.apiProvider);

  Future<LoginResponseModel> login({
    required String phone,
    required String password,
  }) {
    return apiProvider.login(
      phone: phone,
      password: password,
    );
  }
}