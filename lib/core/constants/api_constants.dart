class ApiConstants {
  static const String baseUrl = 'http://192.168.100.50:8000/api';

  // auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  /// Step 2 of login: verify the code sent to the user's email using the
  /// otpToken returned by [login] as the Bearer token.
  /// NOTE: confirm this matches the actual route name in your Laravel
  /// routes/api.php for AuthController::verifyLoginOtp (e.g. it might be
  /// '/auth/login/verify-otp' or '/auth/verify-login-otp' depending on
  /// how you registered it).
  // static const String verifyLoginOtp = '/auth/email/verify-otp';auth/email/verify-otp

  // Separate feature: verifying/re-verifying an email address, unrelated
  // to the login OTP step above.
  static const String sendEmailOtp = '/auth/email/send-otp';
  static const String verifyEmailOtp = '/auth/email/verify-otp';

  static const String logout = '/auth/logout';

  // profile
  static const String profile = '/auth/me';

  static Uri uri(String endpoint) {
    return Uri.parse('$baseUrl$endpoint');
  }
}