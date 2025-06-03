import 'package:picple/data/datasource/profile_data_source.dart';
import 'package:picple/data/model/response/my_photos_response.dart';
import 'package:picple/data/model/response/profile_response.dart';
import '../model/response/base_response.dart';

class ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepository (this._dataSource);

  Future<BaseResponse<ProfileData>> getProfile() async {
    final response = await _dataSource.getProfile();
    return response;
  }

  Future<BaseResponse<ProfileData>> updateProfile(String nickname, String? imagePath) async {
    final response = await _dataSource.updateProfile(nickname, imagePath);
    return response;
  }

  Future<BaseResponse<MyPhotosData>> getMyLikedPhotos() async {
    final response = await _dataSource.getMyLikedPhotos();
    return response;
  }

  Future<BaseResponse<MyPhotosData>> getMyPhotos() async {
    final response = await _dataSource.getMyPhotos();
    return response;
  }
}