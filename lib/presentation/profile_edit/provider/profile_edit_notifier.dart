import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_edit_contract.dart';

final profileEditStateProvider = NotifierProvider<ProfileEditNotifier, ProfileEditState>(() => ProfileEditNotifier());
final profileEditEffectProvider = StateProvider<ProfileEditEffect?>((ref) => null);

class ProfileEditNotifier extends Notifier<ProfileEditState> {
  @override
  ProfileEditState build() {
    return ProfileEditState();
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void setProfileImage(String? imageUrl) {
    state = state.copyWith(profileImageUrl: imageUrl);
  }

  Future<void> saveChanges() async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: 실제 저장 로직 구현
      _showToast("변경사항이 저장되었습니다.");
      _navigateTo("/profile");
    } catch (e) {
      _showToast("저장 실패: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _navigateTo(String route) {
    ref.read(profileEditEffectProvider.notifier).state = NavigateTo(route);
  }

  void _showToast(String message) {
    ref.read(profileEditEffectProvider.notifier).state = ShowToast(message);
  }
} 