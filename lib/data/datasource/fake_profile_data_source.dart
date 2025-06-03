import 'package:picple/data/datasource/profile_data_source.dart';
import 'package:picple/data/model/response/profile_response.dart';
import '../model/response/base_response.dart';

class FakeProfileDataSource extends ProfileDataSource {
  @override
  Future<BaseResponse<ProfileData>> getProfile() async {
    return BaseResponse<ProfileData>.fromJson({
      "isSuccess": true,
      "data": {
        "profileImgUrl": "https://randomuser.me/api/portraits/men/10.jpg",
        "nickname": "JohnDoe",
      }
    }, ProfileData.fromJson);
  }

  @override
  Future<BaseResponse<ProfileData>> updateProfile(String nickname, String? imagePath) async {
    return BaseResponse<ProfileData>.fromJson({
      "isSuccess": true,
      "data": {
        "profileImgUrl": "https://randomuser.me/api/portraits/men/10.jpg",
        "nickname": nickname,
      }
    }, ProfileData.fromJson);
  }
}
