class ProfileEditState {
  final String nickname;
  final String? profileImageUrl;
  final bool isLoading;

  ProfileEditState({
    this.nickname = '',
    this.profileImageUrl,
    this.isLoading = false,
  });

  ProfileEditState copyWith({String? nickname, String? profileImageUrl, bool? isLoading}) {
    return ProfileEditState(
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class ProfileEditEffect {}
class NavigateTo extends ProfileEditEffect {
  final String route;
  NavigateTo(this.route);
}
class ShowToast extends ProfileEditEffect {
  final String message;
  ShowToast(this.message);
} 