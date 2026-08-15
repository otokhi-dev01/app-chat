/// Response returned by POST /auth/login (step 1).
///
/// This is NOT the final login response — there's no access token yet.
/// [otpToken] is a short-lived token that must be sent as the Bearer
/// token on the verify-OTP request; the real access token only comes
/// back from [AuthApiService.verifyLoginOtp].
class LoginOtpResponseModel {
  final String message;
  final String otpToken;
  final String tokenType;
  final int expiresIn;
  final String email;
  final String nextStep;

  const LoginOtpResponseModel({
    required this.message,
    required this.otpToken,
    required this.tokenType,
    required this.expiresIn,
    required this.email,
    required this.nextStep,
  });

  factory LoginOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : const <String, dynamic>{};

    return LoginOtpResponseModel(
      message: json['message']?.toString() ?? '',
      otpToken: json['otpToken']?.toString() ?? '',
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
      email: data['email']?.toString() ?? '',
      nextStep: data['nextStep']?.toString() ?? '',
    );
  }
}