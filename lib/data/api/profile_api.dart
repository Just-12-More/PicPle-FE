import 'package:picple/data/dio_client.dart';
import 'package:picple/data/model/response/profile_response.dart';

import '../model/response/base_response.dart';

class ProfileApi {
  final DioClient _dioClient;

  ProfileApi(this._dioClient);

  Future<BaseResponse<ProfileData>> getProfile() async {
    try {
      final response = await _dioClient.dio.post('/users/info');
      final profileResponse = BaseResponse<ProfileData>.fromJson(response.data, ProfileData.fromJson);
      return profileResponse;
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while logging in: $e',
        ),
      );
    }
  }
} 