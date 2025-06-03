import 'package:picple/data/model/request/geo_photos_request.dart';
import 'package:picple/data/model/request/presigned_url_request.dart';
import 'package:picple/data/model/request/upload_photo_request.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';
import 'package:picple/data/model/response/presigned_url_response.dart';

import '../api/photo_api.dart';
import '../model/request/nearby_photos_request.dart';
import '../model/response/base_response.dart';
import '../model/response/geo_photos_response.dart';

abstract class PhotoDataSource {
  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(GeoPhotosRequest request);

  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(NearbyPhotosRequest request);

  Future<BaseResponse<PhotoData>> uploadPhoto(UploadPhotoRequest request);

  Future<BaseResponse<PreSignedUrlData>> getPreSignedUrl(PreSignedUrlRequest request);
}

class PhotoDataSourceImpl implements PhotoDataSource {
  final PhotoApi _photoApi;

  PhotoDataSourceImpl(this._photoApi);

  @override
  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(GeoPhotosRequest request) {
    return _photoApi.getGeoPhotos(request);
  }

  @override
  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(NearbyPhotosRequest request) {
    return _photoApi.getNearbyPhotos(request);
  }

  @override
  Future<BaseResponse<PhotoData>> uploadPhoto(UploadPhotoRequest request) {
    return _photoApi.uploadPhoto(request);
  }

  @override
  Future<BaseResponse<PreSignedUrlData>> getPreSignedUrl(PreSignedUrlRequest request) {
    return _photoApi.getPreSignedUrl(request);
  }
}