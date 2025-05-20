class LoginResponse {
  final bool isSuccess;
  final LoginData? data;
  final String? error;

  LoginResponse({
    required this.isSuccess,
    this.data,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isSuccess: json['isSuccess'] as bool,
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      error: json['error'] as String?,
    );
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
} 