import 'package:dio/dio.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/data/model/response/my_photos_response.dart';
import 'package:picple/data/model/response/profile_response.dart';

import '../model/response/base_response.dart';

class ProfileApi {
  final DioClient _dioClient;

  ProfileApi(this._dioClient);

  Future<BaseResponse<ProfileData>> getProfile() async {
    try {
      final response = await _dioClient.dio.get('/users/info');
      final profileResponse = BaseResponse<ProfileData>.fromJson(response.data, ProfileData.fromJson);
      return profileResponse;
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while logging in: $e',
        ),
      );
    }
  }

  Future<BaseResponse<ProfileData>> updateProfile(String nickname, String? imagePath) async {
    try {
      MultipartFile? imageFile;

      final formData = FormData();
      formData.fields.add(MapEntry('nickName', nickname));

      if (imagePath != null) {
        imageFile = await MultipartFile.fromFile(
          imagePath
        );

        formData.files.add(MapEntry('image', imageFile));
      } else {
        formData.files.add(MapEntry('image', MultipartFile.fromBytes([], filename: '')));
      }

      final response = await _dioClient.dio.post('/users/info', data: formData);
      final profileResponse = BaseResponse<ProfileData>.fromJson(
        response.data,
        ProfileData.fromJson,
      );
      return profileResponse;
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while updating profile: $e',
        ),
      );
    }
  }

  Future<BaseResponse<MyPhotosData>> getMyLikedPhotos() async {
    try {
      final response = await _dioClient.dio.get('/users/likes');
      final myPhotosResponse = BaseResponse<MyPhotosData>.fromJson(
        response.data,
        MyPhotosData.fromJson,
      );
      return myPhotosResponse;
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while fetching liked photos: $e',
        ),
      );
    }
  }

  Future<BaseResponse<MyPhotosData>> getMyPhotos() async {
    try {
      final response = await _dioClient.dio.get('/users/photos');
      final myPhotosResponse = BaseResponse<MyPhotosData>.fromJson(
        response.data,
        MyPhotosData.fromJson,
      );
      return myPhotosResponse;
    } catch (e) {
      return BaseResponse(
        isSuccess: false,
        error: ResponseError(
          code: "500",
          message: 'An error occurred while fetching liked photos: $e',
        ),
      );
    }
  }
} 