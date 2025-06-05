import 'dart:io';

import 'package:picple/data/datasource/photo_data_source.dart';
import 'package:picple/data/model/response/geo_photos_response.dart';

import '../model/request/geo_photos_request.dart';
import '../model/request/nearby_photos_request.dart';
import '../model/request/presigned_url_request.dart';
import '../model/request/upload_photo_request.dart';
import '../model/response/base_response.dart';
import '../model/response/nearby_photos_response.dart';
import '../model/response/presigned_url_response.dart';

class PhotoRepository {
  final PhotoDataSource _dataSource;

  PhotoRepository(this._dataSource);

  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(
    double latitude,
    double longitude,
    double radius,
  ) async {
    final response = await _dataSource.getGeoPhotos(
      GeoPhotosRequest(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      ),
    );

    return response;
  }

  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(
    double latitude,
    double longitude
  ) async {
    final response = await _dataSource.getNearbyPhotos(
      NearbyPhotosRequest(
        latitude: latitude,
        longitude: longitude,
      ),
    );

    return response;
  }

  Future<BaseResponse<PhotoData>> getPhotoDetail(int photoId) async {
    final response = await _dataSource.getPhotoDetail(photoId);

    return response;
  }

  Future<BaseResponse<PhotoData>> uploadPhoto(
    String imageUrl,
    String title,
    String description,
    double latitude,
    double longitude,
  ) async {
    final response = await _dataSource.uploadPhoto(
      UploadPhotoRequest(
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        photoUrl: imageUrl,
      ),
    );

    return response;
  }

  Future<BaseResponse<PreSignedUrlData>> postPreSignedUrl(String filename) async {
    final response = await _dataSource.postPreSignedUrl(PreSignedUrlRequest(filename: filename));

    return response;
  }

  Future<bool> uploadFileToPreSignedUrl(File file, String preSignedUrl) async {
    final response = await _dataSource.uploadFileToPreSignedUrl(file, preSignedUrl);

    return response;
  }
}