import '../model/request/login_request.dart';
import '../model/response/base_response.dart';
import '../model/response/login_response.dart';

abstract class AuthDataSource {
  Future<BaseResponse<LoginData>> login(LoginRequest request);
}