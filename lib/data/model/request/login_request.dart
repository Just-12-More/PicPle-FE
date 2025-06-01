enum LoginProvider {
  kakao,
  apple,
}

class LoginRequest {
  final String accessToken;
  final LoginProvider provider;

  LoginRequest({
    required this.accessToken,
    required this.provider,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'provider': provider.name.toUpperCase(),
    };
  }
} 