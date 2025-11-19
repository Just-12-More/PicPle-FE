import 'package:picple/data/api/tag_api.dart';
import 'package:picple/data/model/response/base_response.dart';
import 'package:picple/data/model/response/tag_response.dart';

abstract class TagRepository {
  Future<BaseResponse<TagResponse>> getTags();
}

class TagRepositoryImpl implements TagRepository {
  final TagApi _tagApi;

  TagRepositoryImpl(this._tagApi);

  @override
  Future<BaseResponse<TagResponse>> getTags() {
    return _tagApi.getTags();
  }
}
