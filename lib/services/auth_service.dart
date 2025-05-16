import 'package:picple/data/dio_client.dart';
import 'package:picple/models/auth/login_request.dart';
import 'package:picple/models/auth/login_response.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      return LoginResponse(
        isSuccess: false,
        error: e.toString(),
      );
    }
  }
} 