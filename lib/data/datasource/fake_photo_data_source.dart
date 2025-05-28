import 'package:picple/data/datasource/photo_data_source.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';

import '../model/request/geo_photos_request.dart';
import '../model/request/nearby_photos_request.dart';
import '../model/request/upload_photo_request.dart';
import '../model/response/base_response.dart';
import '../model/response/geo_photos_response.dart';

class FakePhotoDataSource implements PhotoDataSource {

  @override
  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(GeoPhotosRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<GeoPhotosData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "address": "서울시 강남구 테헤란로",
          "photos": List.generate(10, (index) {
            return {
              "id": index + 1,
              "title": "사진 ${index + 1}",
              "imgUrl": "https://picsum.photos/id/${100 + index}/300/300",
              "description": "설명 ${index + 1}",
              "nickname": "유저${index + 1}",
              "profileImgUrl": "https://picsum.photos/seed/user${index + 1}/48/48",
              "likeCount": (index + 1) * 5,
              "isLiked": index % 2 == 0,
              "address": "서울시 강남구",
              "latitude": 37.5665 + (index * 0.001),
              "longitude": 126.978 + (index * 0.001),
              "createdAt": DateTime.now().subtract(Duration(days: index)).toIso8601String()
            };
          }),
        },
        "error": null
      },
      GeoPhotosData.fromJson
    );
  }

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
            "latitude": 37.5665,
            "longitude": 126.978,
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
              "latitude": 37.5665 + (index * 0.001),
              "longitude": 126.978 + (index * 0.001),
              "createdAt": "2024-04-01T0${index + 1}:00:00Z"
            };
          }),
        },
        "error": null
      },
      NearbyPhotosData.fromJson
    );
  }

  @override
  Future<BaseResponse<PhotoData>> uploadPhoto(UploadPhotoRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<PhotoData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "id": 100,
          "title": request.title,
          "imgUrl": request.imageUrl,
          "description": request.description,
          "nickname": "테스트유저",
          "profileImgUrl": "https://picsum.photos/seed/testuser/48/48",
          "likeCount": 0,
          "isLiked": false,
          "address": "서울시 강남구",
          "latitude": request.latitude,
          "longitude": request.longitude,
          "createdAt": DateTime.now().toIso8601String()
        },
        "error": null
      },
      PhotoData.fromJson
    );
  }
}