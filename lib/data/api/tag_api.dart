import 'package:picple/data/dio_client.dart';
import 'package:picple/data/model/response/base_response.dart';
import 'package:picple/data/model/response/hot_tags_response.dart';
import 'package:picple/data/model/response/tag_response.dart';
import 'package:picple/data/model/response/tagged_photos_response.dart';

class TagApi {
  final DioClient _dioClient;

  TagApi(this._dioClient);

  Future<BaseResponse<TagResponse>> getTags() async {
    try {
      final response = await _dioClient.dio.get('/photos/tags');
      return BaseResponse<TagResponse>.fromJson(
        response.data,
        TagResponse.fromJson,
      );
    } catch (e) {
      return BaseResponse<TagResponse>(
        isSuccess: false,
        error: ResponseError(
          code: '500',
          message: 'Failed to fetch tags: $e',
        ),
      );
    }
  }

  Future<BaseResponse<TaggedPhotosResponse>> getPhotosByTagId(int tagId) async {
    try {
      final response = await _dioClient.dio.get('/photos/$tagId');
      final responseData =
          Map<String, dynamic>.from(response.data as Map<dynamic, dynamic>);
      final photosJson = responseData['data'] as List<dynamic>?;

      return BaseResponse<TaggedPhotosResponse>(
        isSuccess: responseData['isSuccess'] as bool? ?? false,
        data: photosJson != null
            ? TaggedPhotosResponse.fromList(photosJson)
            : null,
        error: responseData['error'] != null
            ? ResponseError.fromJson(
                Map<String, dynamic>.from(
                  responseData['error'] as Map<dynamic, dynamic>,
                ),
              )
            : null,
      );
    } catch (e) {
      return BaseResponse<TaggedPhotosResponse>(
        isSuccess: false,
        error: ResponseError(
          code: '500',
          message: 'Failed to fetch photos by tag: $e',
        ),
      );
    }
  }

  Future<BaseResponse<HotTagsResponse>> getHotTags() async {
    try {
      final response = await _dioClient.dio.get('/photos/hot-tags');
      final responseData =
          Map<String, dynamic>.from(response.data as Map<dynamic, dynamic>);
      final tagsJson = responseData['data'] as List<dynamic>?;

      return BaseResponse<HotTagsResponse>(
        isSuccess: responseData['isSuccess'] as bool? ?? false,
        data:
            tagsJson != null ? HotTagsResponse.fromList(tagsJson) : null,
        error: responseData['error'] != null
            ? ResponseError.fromJson(
                Map<String, dynamic>.from(
                  responseData['error'] as Map<dynamic, dynamic>,
                ),
              )
            : null,
      );
    } catch (e) {
      return BaseResponse<HotTagsResponse>(
        isSuccess: false,
        error: ResponseError(
          code: '500',
          message: 'Failed to fetch hot tags: $e',
        ),
      );
    }
  }
}
