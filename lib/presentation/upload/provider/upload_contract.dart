import 'dart:io';

import '../../../data/model/response/nearby_photos_response.dart';
import '../../../data/model/response/tag_response.dart';

class UploadState {
  final bool isUploading;
  final File? photo;
  final List<TagItem> nounTags;
  final List<TagItem> adjectiveTags;
  final Set<int> selectedTagIds;

  UploadState({
    this.isUploading = false,
    this.photo,
    this.nounTags = const <TagItem>[],
    this.adjectiveTags = const <TagItem>[],
    this.selectedTagIds = const <int>{},
  });

  UploadState copyWith({
    bool? isUploading,
    File? photo,
    List<TagItem>? nounTags,
    List<TagItem>? adjectiveTags,
    Set<int>? selectedTagIds,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      photo: photo ?? this.photo,
      nounTags: nounTags ?? this.nounTags,
      adjectiveTags: adjectiveTags ?? this.adjectiveTags,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
    );
  }
}

abstract class UploadEffect { }
class UploadSuccess extends UploadEffect {
  final PhotoData photo;
  final List<int> tagIds;
  UploadSuccess(this.photo, this.tagIds);
}
class ShowToast extends UploadEffect {
  final String message;
  ShowToast(this.message);
}

class UploadCompletedResult {
  final PhotoData photo;
  final List<int> tagIds;

  const UploadCompletedResult({required this.photo, required this.tagIds});
}
