import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:picple/data/model/request/geo_photos_request.dart';
import 'package:picple/data/model/request/nearby_photos_request.dart';
import 'package:picple/data/model/request/upload_photo_request.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';

import '../dio_client.dart';
import '../model/request/presigned_url_request.dart';
import '../model/response/base_response.dart';
import '../model/response/geo_photos_response.dart';
import '../model/response/presigned_url_response.dart';

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
            'radius': request.radius,
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

  Future<BaseResponse<PhotoData>> uploadPhoto(
    UploadPhotoRequest request
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/photos/upload',
        data: request.toJson(),
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

  Future<BaseResponse<PreSignedUrlData>> postPreSignedUrl(
    PreSignedUrlRequest request,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/s3/posturl',
        data: request.toJson(),
      );

      return BaseResponse<PreSignedUrlData>.fromJson(
        response.data, PreSignedUrlData.fromJson
      );
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while uploading the file: $e',
        ),
      );
    }
  }

  Future<bool> uploadFileToPreSignedUrl({
    required File file,
    required String preSignedUrl,
  }) async {
    try {
      if (!await file.exists()) return false;

      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final mediaType = MediaType.parse(mimeType);
      final fileLength = await file.length();

      final dio = Dio();

      final response = await dio.put(
        preSignedUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: fileLength,
            Headers.contentTypeHeader: mediaType.toString(),
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      log('[uploadFileToPreSignedUrl] Upload failed: $e\n$stackTrace');
      return false;
    }
  }
}