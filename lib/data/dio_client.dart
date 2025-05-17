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

  TokenInterceptor({required this.storage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await storage.read(key: Constants.ACCESS_TOKEN_KEY);
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
    handler.next(err);
  }
}