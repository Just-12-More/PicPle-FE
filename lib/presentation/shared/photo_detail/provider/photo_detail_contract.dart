import '../../../../data/model/response/nearby_photos_response.dart';
import '../../../../data/model/response/tag_response.dart';

class PhotoDetailState {
  final bool isInitialized;
  final PhotoData photo;

  PhotoDetailState({
    this.isInitialized = false,
    this.photo = const PhotoData(
      id: 0,
      nickname: '',
      profileImgUrl: '',
      imgUrl: '',
      isLiked: false,
      likeCount: 0,
      title: '',
      description: '',
      address: '',
      latitude: 0.0,
      longitude: 0.0,
      createdAt: '',
      tags: <TagItem>[],
    ),
  });

  PhotoDetailState copyWith({
    bool? isInitialized,
    PhotoData? photo,
  }) {
    return PhotoDetailState(
      isInitialized: isInitialized ?? this.isInitialized,
      photo: photo ?? this.photo,
    );
  }
}

abstract class PhotoDetailEffect { }
class ShowToast extends PhotoDetailEffect {
  final String message;
  ShowToast(this.message);
}
