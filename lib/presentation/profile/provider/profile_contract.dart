import 'package:picple/data/model/response/my_photos_response.dart';

class ProfileState {
  final bool isProfileLoading;
  final bool isPhotosLoading;
  final String? profileImage;
  final String? nickname;
  final List<SimplePhotoData> myLikedPhotos;
  final List<SimplePhotoData> myPhotos;

  ProfileState({
    this.isProfileLoading = false,
    this.isPhotosLoading = false,
    this.profileImage,
    this.nickname,
    this.myLikedPhotos = const [],
    this.myPhotos = const [],
  });

  ProfileState copyWith({
    bool? isProfileLoading,
    bool? isPhotosLoading,
    String? profileImage,
    String? nickname,
    List<SimplePhotoData>? myLikedPhotos,
    List<SimplePhotoData>? myPhotos,
  }) {
    return ProfileState(
      isProfileLoading: isProfileLoading ?? this.isProfileLoading,
      isPhotosLoading: isPhotosLoading ?? this.isPhotosLoading,
      profileImage: profileImage ?? this.profileImage,
      nickname: nickname ?? this.nickname,
      myLikedPhotos: myLikedPhotos ?? this.myLikedPhotos,
      myPhotos: myPhotos ?? this.myPhotos,
    );
  }

  bool get isLoading => isProfileLoading || isPhotosLoading;
}

abstract class ProfileEffect {}

class NavigateTo extends ProfileEffect {
  final String route;
  NavigateTo(this.route);
}

class ShowToast extends ProfileEffect {
  final String message;
  ShowToast(this.message);
}
