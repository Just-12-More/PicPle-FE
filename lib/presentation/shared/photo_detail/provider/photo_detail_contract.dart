import '../../../../data/model/response/nearby_photos_response.dart';

class PhotoDetailState {
  final bool isLoading;
  final PhotoData photo;

  PhotoDetailState({
    this.isLoading = false,
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
    ),
  });

  PhotoDetailState copyWith({
    bool? isLoading,
    PhotoData? photo,
  }) {
    return PhotoDetailState(
      isLoading: isLoading ?? this.isLoading,
      photo: photo ?? this.photo,
    );
  }
}

abstract class PhotoDetailEffect { }
class ShowToast extends PhotoDetailEffect {
  final String message;
  ShowToast(this.message);
}