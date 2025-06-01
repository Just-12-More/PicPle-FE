import 'package:picple/data/datasource/profile_data_source.dart';
import 'package:picple/data/model/response/profile_response.dart';
import '../model/response/base_response.dart';

class ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepository (this._dataSource);

  Future<BaseResponse<ProfileData>> getProfile() async {
    final response = await _dataSource.getProfile();
    return response;
  }
}