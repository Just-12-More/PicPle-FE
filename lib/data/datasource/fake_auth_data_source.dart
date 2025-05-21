import 'package:picple/data/datasource/auth_data_source.dart';
import 'package:picple/data/model/request/login_request.dart';
import 'package:picple/data/model/response/login_response.dart';

import '../model/response/base_response.dart';

class FakeAuthDataSource implements AuthDataSource {
  @override
  Future<BaseResponse<LoginData>> login(LoginRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BaseResponse<LoginData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "accessToken": "mock_access_token",
          "refreshToken": "mock_refresh_token"
        }
      },
      LoginData.fromJson
    );
  }
}