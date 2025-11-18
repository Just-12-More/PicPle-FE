class ProfileEditState {
  final String nickname;
  final String? profileImageUrl;
  final String? imagePath;
  final bool isFetching;
  final bool isSaving;

  ProfileEditState({
    this.nickname = '',
    this.profileImageUrl,
    this.imagePath,
    this.isFetching = false,
    this.isSaving = false,
  });

  ProfileEditState copyWith({
    String? nickname,
    String? profileImageUrl,
    bool? isFetching,
    bool? isSaving,
    String? imagePath,
  }) {
    return ProfileEditState(
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      imagePath: imagePath ?? this.imagePath,
      isFetching: isFetching ?? this.isFetching,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

abstract class ProfileEditEffect {}
class NavigateBack extends ProfileEditEffect {}
class ShowToast extends ProfileEditEffect {
  final String message;
  ShowToast(this.message);
} 
