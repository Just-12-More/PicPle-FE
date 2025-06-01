import 'package:picple/data/api/storage_api.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/data/model/request/login_request.dart';
import 'package:picple/data/model/response/login_response.dart';

import '../model/response/base_response.dart';

class AuthApi {
  final DioClient _dioClient;
  final StorageApi _storageService;

  AuthApi(this._dioClient, this._storageService);

  Future<BaseResponse<LoginData>> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      
      final loginResponse = BaseResponse<LoginData>.fromJson(response.data, LoginData.fromJson);
      
      if (loginResponse.isSuccess && loginResponse.data != null) {
        await _storageService.saveTokens(
          accessToken: loginResponse.data!.accessToken,
          refreshToken: loginResponse.data!.refreshToken,
        );
      }
      
      return loginResponse;
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while logging in: $e',
        ),
      );
    }
  }

  Future<BaseResponse<LoginData>> reissue() async {
    try {
      final response = await _dioClient.dio.post('/auth/reissue/token');
      return BaseResponse<LoginData>.fromJson(response.data, LoginData.fromJson);
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while reissuing tokens: $e',
        ),
      );
    }
  }

  Future<BaseResponse<void>> withdrawal() async {
    try {
      final response = await _dioClient.dio.post('/auth/withdrawal');
      return BaseResponse<void>.fromJson(response.data, (_) => null);
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while withdrawing: $e',
        ),
      );
    }
  }

  Future<BaseResponse<void>> logout() async {
    try {
      final response = await _dioClient.dio.post('/auth/logout');
      final logoutResponse = BaseResponse<void>.fromJson(response.data, (_) => null);
      
      return logoutResponse;
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while logging out: $e',
        ),
      );
    }
  }
} 