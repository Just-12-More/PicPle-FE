import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static late final String naverClientId;

  static Future<void> init() async {
    await dotenv.load(fileName: "assets/config/.env");
    naverClientId = dotenv.env['NAVER_CLIENT_ID'] as String;
  }
}