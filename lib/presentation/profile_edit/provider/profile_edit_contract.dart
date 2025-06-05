class ProfileEditState {
  final String nickname;
  final String? profileImageUrl;
  final String? imagePath;
  final bool isLoading;

  ProfileEditState({
    this.nickname = '',
    this.profileImageUrl,
    this.imagePath,
    this.isLoading = false,
  });

  ProfileEditState copyWith({String? nickname, String? profileImageUrl, bool? isLoading, String? imagePath}) {
    return ProfileEditState(
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class ProfileEditEffect {}
class NavigateBack extends ProfileEditEffect {}
class ShowToast extends ProfileEditEffect {
  final String message;
  ShowToast(this.message);
} 