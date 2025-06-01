import 'package:picple/data/api/profile_api.dart';
import 'package:picple/data/model/response/profile_response.dart';
import '../model/response/base_response.dart';

abstract class ProfileDataSource {
  Future<BaseResponse<ProfileData>> getProfile();
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final ProfileApi _profileApi;

  ProfileDataSourceImpl(this._profileApi);

  @override
  Future<BaseResponse<ProfileData>> getProfile() async {
    return await _profileApi.getProfile();
  }
}
