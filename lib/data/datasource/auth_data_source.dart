import '../model/request/login_request.dart';
import '../model/response/login_response.dart';

abstract class AuthDataSource {
  Future<LoginResponse> login(LoginRequest request);
}