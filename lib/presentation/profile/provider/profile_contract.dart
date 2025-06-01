class ProfileState {
  final bool isLoading;
  final String? profileImage;
  final String? nickname;

  ProfileState({
    this.isLoading = false,
    this.profileImage,
    this.nickname,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? profileImage,
    String? nickname,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileImage: profileImage ?? this.profileImage,
      nickname: nickname ?? this.nickname,
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