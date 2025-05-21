import 'package:picple/data/datasource/auth_data_source.dart';
import 'package:picple/data/model/request/login_request.dart';
import 'package:picple/data/model/response/login_response.dart';

class FakeAuthDataSource implements AuthDataSource {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return LoginResponse.fromJson({
      "isSuccess": true,
      "data": {
        "accessToken": "mock_access_token",
        "refreshToken": "mock_refresh_token"
      }
    });
  }
}