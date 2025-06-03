import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picple/data/repository/profile_repository.dart';
import 'package:picple/data/service_providers.dart';
import 'package:picple/presentation/profile/provider/profile_notifier.dart';
import 'package:picple/routes.dart';
import 'profile_edit_contract.dart';

final profileEditStateProvider = NotifierProvider<ProfileEditNotifier, ProfileEditState>(() => ProfileEditNotifier());
final profileEditEffectProvider = StateProvider<ProfileEditEffect?>((ref) => null);

class ProfileEditNotifier extends Notifier<ProfileEditState> {
  late final ProfileRepository _profileRepository;

  @override
  ProfileEditState build() {
    _profileRepository = ref.watch(profileRepositoryProvider);
    Future.microtask(() => _fetchProfile());
    return ProfileEditState();
  }

  Future<void> _fetchProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _profileRepository.getProfile();
      if (response.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          profileImageUrl: response.data?.profileImgUrl,
          nickname: response.data?.nickname,
        );
      } else {
        _showToast("프로필 정보를 가져오지 못했습니다.");
      }
    } catch (e) {
      _showToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isLoading: false);
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
    ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final filePath = pickedFile.path;
      ref.read(profileEditStateProvider.notifier).setImagePath(filePath);
    } else {
      _showToast("이미지를 선택하지 않았습니다.");
    }
  }

  Future<void> saveChanges() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _profileRepository.updateProfile(state.nickname, state.imagePath);
      if (response.isSuccess) {
        ref.watch(profileStateProvider.notifier).setNickname(response.data!.nickname);
        ref.watch(profileStateProvider.notifier).setProfileImage(response.data!.profileImgUrl);
        _showToast("변경사항이 저장되었습니다.");
        _navigateTo(Routes.profile.path);
      } else {
        _showToast("저장 실패: ${response.error?.message ?? '알 수 없는 오류'}");
      }
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