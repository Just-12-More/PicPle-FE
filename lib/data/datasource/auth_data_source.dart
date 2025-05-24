import '../model/request/login_request.dart';
import '../model/response/base_response.dart';
import '../model/response/login_response.dart';
import '../api/auth_api.dart';

abstract class AuthDataSource {
  Future<BaseResponse<LoginData>> login(LoginRequest request);
  Future<BaseResponse<void>> logout();
  Future<BaseResponse<LoginData>> reissue();
  Future<BaseResponse<void>> withdrawal();
}

class AuthDataSourceImpl extends AuthDataSource {
  final AuthApi _authApi;

  AuthDataSourceImpl(this._authApi);

  @override
  Future<BaseResponse<LoginData>> login(LoginRequest request) async {
    return await _authApi.login(request);
  }

  @override
  Future<BaseResponse<void>> logout() async {
    return await _authApi.logout();
  }

  @override
  Future<BaseResponse<LoginData>> reissue() async {
    return await _authApi.reissue();
  }

  @override
  Future<BaseResponse<void>> withdrawal() async {
    return await _authApi.withdrawal();
  }
}
