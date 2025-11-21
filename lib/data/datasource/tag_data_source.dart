import 'package:picple/data/api/tag_api.dart';
import 'package:picple/data/model/response/base_response.dart';
import 'package:picple/data/model/response/hot_tags_response.dart';
import 'package:picple/data/model/response/tag_response.dart';
import 'package:picple/data/model/response/tagged_photos_response.dart';

abstract class TagDataSource {
  Future<BaseResponse<TagResponse>> getTags();

  Future<BaseResponse<TaggedPhotosResponse>> getPhotosByTagId(int tagId);

  Future<BaseResponse<HotTagsResponse>> getHotTags();
}

class TagDataSourceImpl implements TagDataSource {
  final TagApi _tagApi;

  TagDataSourceImpl(this._tagApi);

  @override
  Future<BaseResponse<TagResponse>> getTags() {
    return _tagApi.getTags();
  }

  @override
  Future<BaseResponse<TaggedPhotosResponse>> getPhotosByTagId(int tagId) {
    return _tagApi.getPhotosByTagId(tagId);
  }

  @override
  Future<BaseResponse<HotTagsResponse>> getHotTags() {
    return _tagApi.getHotTags();
  }
}
