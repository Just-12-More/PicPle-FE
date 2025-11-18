import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/repository/profile_repository.dart';
import 'package:picple/data/service_providers.dart';

import '../provider/profile_contract.dart';

final profileStateProvider = NotifierProvider.autoDispose<ProfileNotifier, ProfileState>(() => ProfileNotifier());
final profileEffectProvider = StateProvider.autoDispose<ProfileEffect?>((ref) => null);

class ProfileNotifier extends AutoDisposeNotifier<ProfileState> {
  late final ProfileRepository _profileRepository;

  @override
  ProfileState build() {
    _profileRepository = ref.watch(profileRepositoryProvider);
    Future.microtask(() => _initialize());
    return ProfileState();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _fetchProfile(),
      _fetchPhotos(),
    ]);
  }

  void refreshState() {
    _initialize();
  }

  Future<void> _fetchPhotos() async {
    state = state.copyWith(isPhotosLoading: true);

    try {
      final myLikedPhotosResponse = await _profileRepository.getMyLikedPhotos();
      final myPhotosResponse = await _profileRepository.getMyPhotos();

      if (myLikedPhotosResponse.isSuccess) {
        state = state.copyWith(
          myLikedPhotos: myLikedPhotosResponse.data?.photos ?? [],
        );
      } else {
        showToast("좋아요한 사진 목록을 가져오지 못했습니다.");
      }

      if (myPhotosResponse.isSuccess) {
        state = state.copyWith(
          myPhotos: myPhotosResponse.data?.photos ?? [],
        );
      } else {
        showToast("업로드한 사진 목록을 가져오지 못했습니다.");
      }
    } catch (e) {
      showToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isPhotosLoading: false);
    }
  }

  Future<void> _fetchProfile() async {
    state = state.copyWith(isProfileLoading: true);

    try {
      final response = await _profileRepository.getProfile();
      if (response.isSuccess) {
        state = state.copyWith(
          profileImage: response.data?.profilePath,
          nickname: response.data?.username,
        );
      } else {
        showToast("프로필 정보를 가져오지 못했습니다.");
      }
    } catch (e) {
      showToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isProfileLoading: false);
    }
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void setProfileImage(String? imageUrl) {
    state = state.copyWith(profileImage: imageUrl);
  }

  void navigateTo(String route) {
    ref.read(profileEffectProvider.notifier).state = NavigateTo(route);
  }

  void showToast(String message) {
    ref.read(profileEffectProvider.notifier).state = ShowToast(message);
  }
}
