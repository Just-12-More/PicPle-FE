import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:picple/constants.dart';

class StorageApi {
  final FlutterSecureStorage _storage;

  StorageApi() : _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: Constants.ACCESS_TOKEN_KEY, value: accessToken),
      _storage.write(key: Constants.REFRESH_TOKEN_KEY, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: Constants.ACCESS_TOKEN_KEY);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: Constants.REFRESH_TOKEN_KEY);
  }

  Future<void> deleteTokens() async {
    await Future.wait([
      _storage.delete(key: Constants.ACCESS_TOKEN_KEY),
      _storage.delete(key: Constants.REFRESH_TOKEN_KEY),
    ]);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: Constants.ACCESS_TOKEN_KEY);
    await _storage.delete(key: Constants.REFRESH_TOKEN_KEY);
  }
}
