import 'package:picple/data/datasource/photo_data_source.dart';

import '../model/request/nearby_photos_request.dart';
import '../model/response/base_response.dart';
import '../model/response/nearby_photos_response.dart';

class PhotoRepository {
  final PhotoDataSource _dataSource;

  PhotoRepository(this._dataSource);

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
}