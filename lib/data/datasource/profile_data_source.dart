import 'package:picple/data/api/profile_api.dart';
import 'package:picple/data/model/response/my_photos_response.dart';
import 'package:picple/data/model/response/profile_response.dart';
import '../model/response/base_response.dart';

abstract class ProfileDataSource {
  Future<BaseResponse<ProfileData>> getProfile();
  Future<BaseResponse<ProfileData>> updateProfile(String nickname, String? imagePath);
  Future<BaseResponse<MyPhotosData>> getMyLikedPhotos();
  Future<BaseResponse<MyPhotosData>> getMyPhotos();
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

  @override
  Future<BaseResponse<MyPhotosData>> getMyLikedPhotos() {
    return _profileApi.getMyLikedPhotos();
  }

  @override
  Future<BaseResponse<MyPhotosData>> getMyPhotos() {
    return _profileApi.getMyPhotos();
  }
}
