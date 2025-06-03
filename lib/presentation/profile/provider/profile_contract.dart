class ProfileState {
  final bool isLoading;
  final String? profileImage;
  final String? nickname;
  final List<String> myLikedPhotos;
  final List<String> myPhotos;

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
    List<String>? myLikedPhotos,
    List<String>? myPhotos,
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