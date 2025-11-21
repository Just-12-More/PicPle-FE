import 'dart:io';

import 'package:picple/data/datasource/photo_data_source.dart';
import 'package:picple/data/model/request/presigned_url_request.dart';
import 'package:picple/data/model/response/hot_places_response.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';
import 'package:picple/data/model/response/presigned_url_response.dart';

import '../model/request/geo_photos_request.dart';
import '../model/request/upload_photo_request.dart';
import '../model/response/base_response.dart';
import '../model/response/geo_photos_response.dart';

class FakePhotoDataSource implements PhotoDataSource {

  int _photoIdCounter = 1;

  @override
  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(GeoPhotosRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final photos = List.generate(10, (index) {
      final id = _photoIdCounter++;
      return {
        "id": id,
        "title": "사진 $id",
        "imgUrl": "https://picsum.photos/id/${100 + id}/300/300",
        "description": "설명 $id",
        "nickname": "유저$id",
        "profileImgUrl": "https://picsum.photos/seed/user$id/48/48",
        "likeCount": id * 5,
        "isLiked": id % 2 == 0,
        "address": "서울시 강남구",
        "latitude": request.latitude + (index * 0.001),
        "longitude": request.longitude + (index * 0.001),
        "createdAt": DateTime.now().subtract(Duration(days: index)).toIso8601String(),
      };
    });

    return BaseResponse<GeoPhotosData>.fromJson(
        {
          "isSuccess": true,
          "data": {
            "address": "서울시 강남구 테헤란로",
            "photos": photos,
          },
          "error": null
        },
        GeoPhotosData.fromJson
    );
  }

  @override
  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(int centerPhotoId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<NearbyPhotosData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "address": "서울시 강남구 테헤란로",
          "centerPhoto": {
            "id": centerPhotoId,
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
  Future<BaseResponse<PhotoData>> getPhotoDetail(int photoId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<PhotoData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "id": photoId,
          "title": "사진 $photoId",
          "imgUrl": "https://picsum.photos/id/${100 + photoId}/300/300",
          "description": "설명 $photoId",
          "nickname": "유저$photoId",
          "profileImgUrl": "https://picsum.photos/seed/user$photoId/48/48",
          "likeCount": photoId * 5,
          "isLiked": photoId % 2 == 0,
          "address": "서울시 강남구",
          "latitude": 37.5665 + (photoId * 0.001),
          "longitude": 126.978 + (photoId * 0.001),
          "createdAt": DateTime.now().subtract(Duration(days: photoId)).toIso8601String()
        },
        "error": null
      },
      PhotoData.fromJson
    );
  }

  @override
  Future<BaseResponse<HotPlacesData>> getHotPlacesTop10() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BaseResponse<HotPlacesData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "hotplaces": [
            {
              "order": 1,
              "locationLabel": "경기도 수원시 팔달구 지동",
              "photoCnt": 7,
              "imgUrl": "https://picsum.photos/id/201/300/300",
              "latitude": "37.2816337",
              "longitude": "127.0222369"
            },
            {
              "order": 2,
              "locationLabel": "경기도 수원시 팔달구 행궁동",
              "photoCnt": 7,
              "imgUrl": "https://picsum.photos/id/202/300/300",
              "latitude": "37.2841940",
              "longitude": "127.0191077"
            },
            {
              "order": 3,
              "locationLabel": "서울특별시 강남구 역삼1동",
              "photoCnt": 5,
              "imgUrl": "https://picsum.photos/id/203/300/300",
              "latitude": "37.5050333",
              "longitude": "127.0412409"
            },
            {
              "order": 4,
              "locationLabel": "경기도 용인시 처인구 포곡읍",
              "photoCnt": 4,
              "imgUrl": "https://picsum.photos/id/204/300/300",
              "latitude": "37.2933272",
              "longitude": "127.2013221"
            },
            {
              "order": 5,
              "locationLabel": "경기도 용인시 수지구 죽전3동",
              "photoCnt": 3,
              "imgUrl": "https://picsum.photos/id/205/300/300",
              "latitude": "37.3207277",
              "longitude": "127.1276811"
            },
            {
              "order": 6,
              "locationLabel": "경기도 용인시 기흥구 보라동",
              "photoCnt": 3,
              "imgUrl": "https://picsum.photos/id/206/300/300",
              "latitude": "37.2594023",
              "longitude": "127.1205573"
            },
            {
              "order": 7,
              "locationLabel": "경기도 수원시 장안구 정자2동",
              "photoCnt": 3,
              "imgUrl": "https://picsum.photos/id/207/300/300",
              "latitude": "37.2873924",
              "longitude": "126.9915605"
            },
            {
              "order": 8,
              "locationLabel": "서울특별시 용산구 서빙고동",
              "photoCnt": 3,
              "imgUrl": "https://picsum.photos/id/208/300/300",
              "latitude": "37.5240867",
              "longitude": "126.9803880"
            },
            {
              "order": 9,
              "locationLabel": "서울특별시 송파구 잠실3동",
              "photoCnt": 3,
              "imgUrl": "https://picsum.photos/id/209/300/300",
              "latitude": "37.5110880",
              "longitude": "127.0982822"
            },
            {
              "order": 10,
              "locationLabel": "서울특별시 종로구 가회동",
              "photoCnt": 2,
              "imgUrl": "https://picsum.photos/id/210/300/300",
              "latitude": "37.5811911",
              "longitude": "126.9846929"
            }
          ]
        },
        "error": null
      },
      HotPlacesData.fromJson,
    );
  }

  @override
  Future<BaseResponse<void>> likePhoto(int photoId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<void>.fromJson(
      {
        "isSuccess": true,
        "data": null,
        "error": null
      },
      (json) => { }
    );
  }

  @override
  Future<BaseResponse<void>> unlikePhoto(int photoId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<void>.fromJson(
      {
        "isSuccess": true,
        "data": null,
        "error": null
      },
      (json) => { }
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
          "imgUrl": request.photoUrl,
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

  @override
  Future<BaseResponse<PreSignedUrlData>> postPreSignedUrl(PreSignedUrlRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BaseResponse<PreSignedUrlData>.fromJson(
      {
        "isSuccess": true,
        "data": {
          "preSignedUrl": "https://mock-s3-url.com/${request.filename}",
          "key": request.filename
        },
        "error": null
      },
      PreSignedUrlData.fromJson
    );
  }

  @override
  Future<bool> uploadFileToPreSignedUrl(File file, String preSignedUrl) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
