import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static const _defaultSocketUrl =
      'ws://121.78.128.117:8080/ws-connection';
  static const _defaultSocketDestination = '/topic/hot-places';

  static late final String naverClientId;
  static late final String kakaoNativeAppKey;
  static late final String baseUrl;
  static late final String socketUrl;
  static String? socketDestination;

  static Future<void> init() async {
    await dotenv.load(fileName: "assets/config/.env");

    baseUrl = dotenv.env['BASE_URL'] as String;
    naverClientId = dotenv.env['NAVER_CLIENT_ID'] as String;
    kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] as String;
    socketUrl = dotenv.env['SOCKET_URL'] ?? _defaultSocketUrl;
    socketDestination =
        dotenv.env['SOCKET_DESTINATION'] ?? _defaultSocketDestination;
  }
}
