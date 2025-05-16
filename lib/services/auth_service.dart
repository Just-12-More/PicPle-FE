import 'package:picple/data/dio_client.dart';
import 'package:picple/models/auth/login_request.dart';
import 'package:picple/models/auth/login_response.dart';
import 'package:picple/services/storage_service.dart';

class AuthService {
  final DioClient _dioClient;
  final StorageService _storageService;

  AuthService(this._dioClient, this._storageService);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      
      final loginResponse = LoginResponse.fromJson(response.data);
      
      if (loginResponse.isSuccess && loginResponse.data != null) {
        await _storageService.saveTokens(
          accessToken: loginResponse.data!.accessToken,
          refreshToken: loginResponse.data!.refreshToken,
        );
      }
      
      return loginResponse;
    } catch (e) {
      return LoginResponse(
        isSuccess: false,
        error: e.toString(),
      );
    }
  }
} 