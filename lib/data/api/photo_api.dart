import 'package:picple/data/model/request/geo_photos_request.dart';
import 'package:picple/data/model/request/nearby_photos_request.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';

import '../dio_client.dart';
import '../model/response/base_response.dart';
import '../model/response/geo_photos_response.dart';

class PhotoApi {
  final DioClient _dioClient;

  PhotoApi(this._dioClient);

  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(
    GeoPhotosRequest request
  ) async {
    try {
      final response = await _dioClient.dio.post(
          '/photos',
          data: {
            'latitude': request.latitude,
            'longitude': request.longitude,
            'leftTopLatitude': request.leftTopLatitude,
            'leftTopLongitude': request.leftTopLongitude,
            'rightBottomLatitude': request.rightBottomLatitude,
            'rightBottomLongitude': request.rightBottomLongitude,
          }
      );

      final geoPhotosResponse = BaseResponse<GeoPhotosData>.fromJson(
        response.data,
        GeoPhotosData.fromJson,
      );

      return geoPhotosResponse;
    } catch (e) {
      return BaseResponse<GeoPhotosData>(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while fetching photo details: $e',
        ),
      );
    }
  }

  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(
    NearbyPhotosRequest request
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/photos/nearby',
        data: request.toJson(),
      );

      final nearbyPhotosResponse = BaseResponse<NearbyPhotosData>.fromJson(
        response.data,
        NearbyPhotosData.fromJson,
      );

      return nearbyPhotosResponse;
    } catch (e) {
      return BaseResponse<NearbyPhotosData>(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while fetching nearby photos: $e',
        ),
      );
    }
  }

  Future<BaseResponse<PhotoData>> uploadFeed(
    String imageUrl,
    String title,
    String description,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/photos',
        data: {
          'imageUrl': imageUrl,
          'title': title,
          'description': description,
        },
      );

      final uploadResponse = BaseResponse<PhotoData>.fromJson(
        response.data,
        PhotoData.fromJson,
      );

      return uploadResponse;
    } catch (e) {
      return BaseResponse<PhotoData>(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while uploading the photo: $e',
        ),
      );
    }
  }
}