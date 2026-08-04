import '../../core/constants/api_constants.dart';
import '../../services/api_service.dart';
import '../model/login_response_model.dart';

class AuthApiProvider {
  final ApiService apiService;

  AuthApiProvider(this.apiService);

  Future<LoginResponseModel> login({
    required String phone,
    required String password,
  }) async {
    final json = await apiService.post(
      ApiConstants.login,
      body: {
        'phone': phone,
        'password': password,
      },
    );

    return LoginResponseModel.fromJson(json);
  }
}