import 'package:picple/data/datasource/profile_data_source.dart';
import 'package:picple/data/model/response/my_photos_response.dart';
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

  @override
  Future<BaseResponse<MyPhotosData>> getMyLikedPhotos() async {
    return BaseResponse<MyPhotosData>.fromJson({
      "isSuccess": true,
      "data": {
        "address": "123 Main St, Anytown, USA",
        "photos": List.generate(15, (index) {
          return {
            "id": index + 2,
            "title": "주변 사진 ${index + 1}",
            "imgUrl": "https://picsum.photos/id/${102 + index}/300/300",
            "description": "이곳도 가까워요",
            "nickname": "유저${index + 1}",
            "profileImgUrl": "https://picsum.photos/seed/user${index + 2}/48/48",
            "likeCount": (index + 1) * 10,
            "isLiked": index % 2 == 0,
            "address": "서울시",
            "latitude": 37.5665 + (index * 0.001),
            "longitude": 126.978 + (index * 0.001),
            "createdAt": "2024-04-01T0${index + 1}:00:00Z"
          };
        })
      }
    }, MyPhotosData.fromJson);
  }

  @override
  Future<BaseResponse<MyPhotosData>> getMyPhotos() async {
    return BaseResponse<MyPhotosData>.fromJson({
      "isSuccess": true,
      "data": {
        "address": "123 Main St, Anytown, USA",
        "photos": List.generate(15, (index) {
          return {
            "id": index + 2,
            "title": "주변 사진 ${index + 1}",
            "imgUrl": "https://picsum.photos/id/${202 + index}/300/300",
            "description": "이곳도 가까워요",
            "nickname": "유저${index + 1}",
            "profileImgUrl": "https://picsum.photos/seed/user${index + 2}/48/48",
            "likeCount": (index + 1) * 10,
            "isLiked": index % 2 == 0,
            "address": "서울시",
            "latitude": 37.5665 + (index * 0.001),
            "longitude": 126.978 + (index * 0.001),
            "createdAt": "2024-04-01T0${index + 1}:00:00Z"
          };
        })
      }
    }, MyPhotosData.fromJson);
  }
}
