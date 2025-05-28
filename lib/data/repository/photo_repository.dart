import 'package:picple/data/datasource/photo_data_source.dart';
import 'package:picple/data/model/response/geo_photos_response.dart';

import '../model/request/geo_photos_request.dart';
import '../model/request/nearby_photos_request.dart';
import '../model/request/upload_photo_request.dart';
import '../model/response/base_response.dart';
import '../model/response/nearby_photos_response.dart';

class PhotoRepository {
  final PhotoDataSource _dataSource;

  PhotoRepository(this._dataSource);

  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(
    double latitude,
    double longitude
  ) async {
    final response = await _dataSource.getGeoPhotos(
      GeoPhotosRequest(
        latitude: latitude,
        longitude: longitude,
        leftTopLatitude: latitude - 0.01, // Example offset for left top corner
        leftTopLongitude: longitude - 0.01, // Example offset for left top corner
        rightBottomLatitude: latitude + 0.01, // Example offset for right bottom corner
        rightBottomLongitude: longitude + 0.01, // Example offset for right bottom corner
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
        imageUrl: imageUrl,
      ),
    );

    return response;
  }
}