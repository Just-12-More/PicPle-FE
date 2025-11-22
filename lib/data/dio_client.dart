import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:picple/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config.dart';

class DioClient {
  late final Dio _dio;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  DioClient() {
    final options = BaseOptions(
      contentType: Headers.jsonContentType,
      baseUrl: Config.baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 30000),
    );

    _dio = Dio(options)
      ..httpClientAdapter = IOHttpClientAdapter()
      ..interceptors.addAll([
        TokenInterceptor(storage: storage),
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        )
      ]);
  }

  Dio get dio => _dio;
}

class TokenInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  Future<bool>? _refreshFuture;

  TokenInterceptor({required this.storage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // 로그인 시에는 토큰을 전달하지 않음
      if (options.path.contains('/auth/login')) {
        handler.next(options);
        return;
      }
      String tokenKey = Constants.ACCESS_TOKEN_KEY;
      // 토큰 재발급 시에는 refresh token을 전달함
      if (options.path.contains('/auth/reissue/token')) {
        tokenKey = Constants.REFRESH_TOKEN_KEY;
      }
      final token = await storage.read(key: tokenKey);
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    } catch (e) {
      print('Failed to read token: $e');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final originalRequest = err.requestOptions;

    try {
      final refreshed = await _refreshTokenIfNeeded();
      if (!refreshed) {
        handler.next(err);
        return;
      }

      final newAccessToken = await storage.read(key: Constants.ACCESS_TOKEN_KEY);
      if (newAccessToken == null) {
        handler.next(err);
        return;
      }

      originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
      final dio = Dio()..httpClientAdapter = IOHttpClientAdapter();
      final retryResponse = await dio.fetch(originalRequest);
      handler.resolve(retryResponse);
    } catch (e) {
      handler.next(err);
    }
  }

  Future<bool> _refreshTokenIfNeeded() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    final refreshToken = await storage.read(key: Constants.REFRESH_TOKEN_KEY);
    if (refreshToken == null) {
      print('Refresh token is missing. Logging out.');
      return false;
    }

    final options = BaseOptions(
      contentType: Headers.jsonContentType,
      validateStatus: (_) => true,
    );

    final dio = Dio(options)
      ..httpClientAdapter = IOHttpClientAdapter()
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );

    final completer = Completer<bool>();
    _refreshFuture = completer.future;

    try {
      final response = await dio.post(
        '${Config.baseUrl}/auth/reissue/token',
        data: {'refreshToken': refreshToken},
      );

      final responseData = response.data;
      if (responseData is! Map || responseData['data'] is! Map) {
        throw Exception('Unexpected refresh token response: $responseData');
      }

      final data = responseData['data'] as Map;
      final newAccessToken = data['token'];
      final newRefreshToken = data['refreshToken'];

      if (newAccessToken == null || newRefreshToken == null) {
        throw Exception('Refresh token response missing fields: $data');
      }

      await storage.write(key: Constants.ACCESS_TOKEN_KEY, value: newAccessToken);
      await storage.write(key: Constants.REFRESH_TOKEN_KEY, value: newRefreshToken);

      completer.complete(true);
      return true;
    } catch (e) {
      completer.completeError(e);
      print('Failed to refresh token: $e');
      return false;
    } finally {
      _refreshFuture = null;
    }
  }
}
