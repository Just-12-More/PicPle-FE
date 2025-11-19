import 'package:picple/data/dio_client.dart';
import 'package:picple/data/model/response/base_response.dart';
import 'package:picple/data/model/response/tag_response.dart';

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
}
