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
  bool _isRefreshing = false;

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
  if (err.response?.statusCode == 401 && !_isRefreshing) {
    _isRefreshing = true;
    try {
      final refreshToken = await storage.read(key: Constants.REFRESH_TOKEN_KEY);
      if (refreshToken == null) {
        // Refresh token이 없으면 로그아웃 처리
        print('Refresh token is missing. Logging out.');
        handler.next(err);
        return;
      }

      final response = await Dio().post(
        '${Config.baseUrl}/auth/reissue/token',
        options: Options(headers: {
          'Authorization': 'Bearer $refreshToken',
        }),
      );

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];
      await storage.write(key: Constants.ACCESS_TOKEN_KEY, value: newAccessToken);
      await storage.write(key: Constants.REFRESH_TOKEN_KEY, value: newRefreshToken);

      // 원래 요청 재시도
      final originalRequest = err.requestOptions;
      originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await Dio().fetch(originalRequest);
      handler.resolve(retryResponse);
      return;
    } catch (e) {
      print('Failed to refresh token: $e');
    } finally {
      _isRefreshing = false;
    }
  }
  handler.next(err);
  }
}