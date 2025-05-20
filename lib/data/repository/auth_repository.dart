import 'package:picple/data/datasource/auth_data_source.dart';
import 'package:picple/data/model/request/login_request.dart';
import 'package:picple/data/services/storage_service.dart';

import '../model/response/login_response.dart';

class AuthRepository {
  final AuthDataSource _dataSource;
  final StorageService _storageService;

  AuthRepository(this._dataSource, this._storageService);

  Future<LoginResponse> login(String accessToken, LoginProvider provider) async {
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
}