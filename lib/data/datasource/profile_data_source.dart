import 'package:picple/data/api/profile_api.dart';
import 'package:picple/data/model/response/profile_response.dart';
import '../model/response/base_response.dart';

abstract class ProfileDataSource {
  Future<BaseResponse<ProfileData>> getProfile();
  Future<BaseResponse<ProfileData>> updateProfile(String nickname, String? imagePath);
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final ProfileApi _profileApi;

  ProfileDataSourceImpl(this._profileApi);

  @override
  Future<BaseResponse<ProfileData>> getProfile() {
    return _profileApi.getProfile();
  }

  @override
  Future<BaseResponse<ProfileData>> updateProfile(String nickname, String? imagePath) {
    return _profileApi.updateProfile(nickname, imagePath);
  }
}
