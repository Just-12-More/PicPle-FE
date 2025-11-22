import 'dart:io';

import 'package:picple/data/model/request/geo_photos_request.dart';
import 'package:picple/data/model/request/presigned_url_request.dart';
import 'package:picple/data/model/request/recommend_photos_request.dart';
import 'package:picple/data/model/request/upload_photo_request.dart';
import 'package:picple/data/model/response/hot_places_response.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';
import 'package:picple/data/model/response/presigned_url_response.dart';
import 'package:picple/data/model/response/recommend_photos_response.dart';
import 'package:picple/data/model/response/stat_photos_response.dart';

import '../api/photo_api.dart';
import '../model/response/base_response.dart';
import '../model/response/geo_photos_response.dart';

abstract class PhotoDataSource {
  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(GeoPhotosRequest request);

  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(int centerPhotoId);

  Future<BaseResponse<PhotoData>> getPhotoDetail(int photoId);

  Future<BaseResponse<HotPlacesData>> getHotPlacesTop10();

  Future<BaseResponse<StatPhotosData>> getStatPhotos(String location);

  Future<BaseResponse<void>> likePhoto(int photoId);

  Future<BaseResponse<void>> unlikePhoto(int photoId);

  Future<BaseResponse<PhotoData>> uploadPhoto(UploadPhotoRequest request);

  Future<BaseResponse<PreSignedUrlData>> postPreSignedUrl(PreSignedUrlRequest request);

  Future<bool> uploadFileToPreSignedUrl(File file, String preSignedUrl);

  Future<BaseResponse<RecommendPhotosResponse>> getRecommendedPhotos(
    RecommendPhotosRequest request,
  );
}

class PhotoDataSourceImpl implements PhotoDataSource {
  final PhotoApi _photoApi;

  PhotoDataSourceImpl(this._photoApi);

  @override
  Future<BaseResponse<GeoPhotosData>> getGeoPhotos(GeoPhotosRequest request) {
    return _photoApi.getGeoPhotos(request);
  }

  @override
  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(int centerPhotoId) {
    return _photoApi.getNearbyPhotos(centerPhotoId);
  }

  @override
  Future<BaseResponse<PhotoData>> getPhotoDetail(int photoId) {
    return _photoApi.getPhotoDetail(photoId);
  }

  @override
  Future<BaseResponse<HotPlacesData>> getHotPlacesTop10() {
    return _photoApi.getHotPlacesTop10();
  }

  @override
  Future<BaseResponse<StatPhotosData>> getStatPhotos(String location) {
    return _photoApi.getStatPhotos(location);
  }

  @override
  Future<BaseResponse<void>> likePhoto(int photoId) {
    return _photoApi.likePhoto(photoId);
  }

  @override
  Future<BaseResponse<void>> unlikePhoto(int photoId) {
    return _photoApi.unlikePhoto(photoId);
  }

  @override
  Future<BaseResponse<PhotoData>> uploadPhoto(UploadPhotoRequest request) {
    return _photoApi.uploadPhoto(request);
  }

  @override
  Future<BaseResponse<PreSignedUrlData>> postPreSignedUrl(PreSignedUrlRequest request) {
    return _photoApi.postPreSignedUrl(request);
  }

  @override
  Future<bool> uploadFileToPreSignedUrl(File file, String preSignedUrl) async {
    return _photoApi.uploadFileToPreSignedUrl(file: file, preSignedUrl: preSignedUrl);
  }

  @override
  Future<BaseResponse<RecommendPhotosResponse>> getRecommendedPhotos(
      RecommendPhotosRequest request) {
    return _photoApi.getRecommendedPhotos(request);
  }
}
