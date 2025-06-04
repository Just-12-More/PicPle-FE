import 'package:picple/data/datasource/auth_data_source.dart';
import 'package:picple/data/model/request/login_request.dart';
import 'package:picple/data/model/request/presigned_url_request.dart';
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

  @override
  Future<BaseResponse<LoginData>> reissue() async {
    await Future.delayed(const Duration(microseconds: 300));
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

  @override
  Future<BaseResponse<void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BaseResponse<void>.fromJson(
      {"isSuccess": true},
      (_) => null
    );
  }

  @override
  Future<BaseResponse<void>> withdrawal() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BaseResponse<void>.fromJson(
      {"isSuccess": true},
      (_) => null
    );
  }

  @override
  Future<BaseResponse<String>> getS3Url(PreSignedUrlRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BaseResponse<String>.fromJson(
      {
        "isSuccess": true,
        "data": "https://mock-s3-url.com/image.jpg"
      },
      (data) => '$data'
    );
  }
}