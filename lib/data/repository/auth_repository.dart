import 'package:picple/data/datasource/auth_data_source.dart';
import 'package:picple/data/model/request/login_request.dart';

import '../api/storage_api.dart';
import '../model/response/base_response.dart';
import '../model/response/login_response.dart';

class AuthRepository {
  final AuthDataSource _dataSource;
  final StorageApi _storageService;

  AuthRepository(this._dataSource, this._storageService);

  Future<BaseResponse<LoginData>> login(String accessToken, LoginProvider provider) async {
    final response = await _dataSource.login(
      LoginRequest(
        accessToken: accessToken,
        provider: provider,
      ),
    );

    if (response.isSuccess && response.data != null) {
      await _storageService.saveTokens(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );
    }

    return response;
  }

  Future<BaseResponse<LoginData>> reissue() async {
    final response = await _dataSource.reissue();

    if (response.isSuccess && response.data != null) {
      await _storageService.saveTokens(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );
    }

    return response;
  }
  
  Future<BaseResponse<void>> logout() async {
    final response = await _dataSource.logout();

    if (response.isSuccess) {
      await _storageService.clearTokens();
    }

    return response;
  }

  Future<BaseResponse<void>> withdrawal() async {
    final response = await _dataSource.withdrawal();

    if (response.isSuccess) {
      await _storageService.clearTokens();
    }

    return response;
  }
}