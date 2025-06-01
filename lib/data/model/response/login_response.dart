class LoginData {
  final String accessToken;
  final String refreshToken;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
} 