import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/core/service/native_media_picker.dart';
import 'package:picple/data/repository/profile_repository.dart';
import 'package:picple/data/service_providers.dart';
import 'package:picple/presentation/profile/provider/profile_notifier.dart';

import 'profile_edit_contract.dart';

final profileEditStateProvider = NotifierProvider.autoDispose<ProfileEditNotifier, ProfileEditState>(() => ProfileEditNotifier());
final profileEditEffectProvider = StateProvider.autoDispose<ProfileEditEffect?>((ref) => null);

class ProfileEditNotifier extends AutoDisposeNotifier<ProfileEditState> {
  late final ProfileRepository _profileRepository;

  @override
  ProfileEditState build() {
    _profileRepository = ref.watch(profileRepositoryProvider);
    Future.microtask(() => _fetchProfile());
    return ProfileEditState();
  }

  Future<void> _fetchProfile() async {
    state = state.copyWith(isFetching: true);

    try {
      final response = await _profileRepository.getProfile();
      if (response.isSuccess) {
        state = state.copyWith(
          profileImageUrl: response.data?.profilePath,
          nickname: response.data?.username,
        );
      } else {
        _showToast("프로필 정보를 가져오지 못했습니다.");
      }
    } catch (e) {
      _showToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isFetching: false);
    }
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void setProfileImage(String? imageUrl) {
    state = state.copyWith(profileImageUrl: imageUrl);
  }

  void setImagePath(String? imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void changeProfileImage() async {
    final file = await NativeMediaPicker.pickFromGallery();

    if (file != null) {
      setImagePath(file.path);
    } else {
      _showToast("이미지를 선택하지 않았습니다.");
    }
  }

  Future<void> saveChanges() async {
    state = state.copyWith(isSaving: true);
    try {
      final response = await _profileRepository.updateProfile(state.nickname, state.imagePath);
      if (response.isSuccess) {
        ref.watch(profileStateProvider.notifier).setNickname(response.data!.username);
        ref.watch(profileStateProvider.notifier).setProfileImage(response.data!.profilePath);
        _showToast("변경사항이 저장되었습니다.");
        _navigateBack();
      } else {
        _showToast("저장 실패: ${response.error?.message ?? '알 수 없는 오류'}");
      }
    } catch (e) {
      _showToast("저장 실패: $e");
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  void _navigateBack() {
    ref.read(profileEditEffectProvider.notifier).state = NavigateBack();
  }

  void _showToast(String message) {
    ref.read(profileEditEffectProvider.notifier).state = ShowToast(message);
  }
} 
