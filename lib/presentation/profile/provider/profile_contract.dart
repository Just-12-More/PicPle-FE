import 'package:picple/data/model/response/my_photos_response.dart';

class ProfileState {
  final bool isLoading;
  final String? profileImage;
  final String? nickname;
  final List<SimplePhotoData> myLikedPhotos;
  final List<SimplePhotoData> myPhotos;

  ProfileState({
    this.isLoading = false,
    this.profileImage,
    this.nickname,
    this.myLikedPhotos = const [],
    this.myPhotos = const [],
  });

  ProfileState copyWith({
    bool? isLoading,
    String? profileImage,
    String? nickname,
    List<SimplePhotoData>? myLikedPhotos,
    List<SimplePhotoData>? myPhotos,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileImage: profileImage ?? this.profileImage,
      nickname: nickname ?? this.nickname,
      myLikedPhotos: myLikedPhotos ?? this.myLikedPhotos,
      myPhotos: myPhotos ?? this.myPhotos,
    );
  }
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