import 'package:picple/data/api/tag_api.dart';
import 'package:picple/data/datasource/tag_data_source.dart';
import 'package:picple/data/model/response/base_response.dart';
import 'package:picple/data/model/response/hot_tags_response.dart';
import 'package:picple/data/model/response/tag_response.dart';
import 'package:picple/data/model/response/tagged_photos_response.dart';

abstract class TagRepository {
  Future<BaseResponse<TagResponse>> getTags();

  Future<BaseResponse<TaggedPhotosResponse>> getPhotosByTagId(int tagId);

  Future<BaseResponse<HotTagsResponse>> getHotTags();
}

class TagRepositoryImpl implements TagRepository {
  final TagDataSource _tagDataSource;

  TagRepositoryImpl(TagApi tagApi) : _tagDataSource = TagDataSourceImpl(tagApi);

  @override
  Future<BaseResponse<TagResponse>> getTags() {
    return _tagDataSource.getTags();
  }

  @override
  Future<BaseResponse<TaggedPhotosResponse>> getPhotosByTagId(int tagId) {
    return _tagDataSource.getPhotosByTagId(tagId);
  }

  @override
  Future<BaseResponse<HotTagsResponse>> getHotTags() {
    return _tagDataSource.getHotTags();
  }
}
