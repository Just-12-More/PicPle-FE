import 'package:picple/data/datasource/photo_data_source.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';

import '../model/request/nearby_photos_request.dart';
import '../model/response/base_response.dart';

class FakePhotoDataSource implements PhotoDataSource {
  @override
  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(NearbyPhotosRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<NearbyPhotosData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "address": "서울시 강남구 테헤란로",
          "centerPhoto": {
            "id": 1,
            "title": "중앙 사진",
            "imgUrl": "https://picsum.photos/id/101/300/300",
            "description": "이곳이 중심이에요!",
            "nickname": "홍길동",
            "profileImgUrl": "https://picsum.photos/seed/user1/48/48",
            "likeCount": 120,
            "isLiked": true,
            "address": "서울시 강남구",
            "createdAt": "2024-04-01T12:00:00Z"
          },
          "nearbyPhotos": List.generate(5, (index) {
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
              "createdAt": "2024-04-01T0${index + 1}:00:00Z"
            };
          }),
        },
        "error": null
      },
      NearbyPhotosData.fromJson
    );
  }
}