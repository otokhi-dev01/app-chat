class LoginResponseModel {
  final int code;
  final String message;
  final LoginDataModel? data;

  LoginResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginDataModel.fromJson(json['data']) : null,
    );
  }
}

class LoginDataModel {
  final String userId;
  final String fullName;
  final String phone;
  final String deviceName;
  final String deviceType;
  final String token;

  LoginDataModel({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.deviceName,
    required this.deviceType,
    required this.token,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      deviceName: json['deviceName'] ?? '',
      deviceType: json['deviceType'] ?? '',
      token: json['token'] ?? '',
    );
  }
}