import 'package:picple/data/model/request/geo_photos_request.dart';
import 'package:picple/data/model/request/upload_photo_request.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';

import '../model/request/nearby_photos_request.dart';
import '../model/response/base_response.dart';
import '../model/response/geo_photos_response.dart';

abstract class PhotoDataSource {
  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(GeoPhotosRequest request);

  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(NearbyPhotosRequest request);

  Future<BaseResponse<PhotoData>> uploadPhoto(UploadPhotoRequest request);
}