import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/repository/photo_repository.dart';
import 'package:picple/presentation/shared/photo_detail/provider/photo_detail_contract.dart';

import '../../../../data/service_providers.dart';

final photoDetailStateProvider = NotifierProvider.autoDispose<PhotoDetailNotifier, PhotoDetailState>(() => PhotoDetailNotifier());
final photoDetailEffectProvider = StateProvider.autoDispose<PhotoDetailEffect?>((ref) => null);

class PhotoDetailNotifier extends AutoDisposeNotifier<PhotoDetailState> {
  late final PhotoRepository _photoRepository;

  @override
  PhotoDetailState build() {
    _photoRepository = ref.watch(photoRepositoryProvider); // Initial fetch with dummy ID
    return PhotoDetailState();
  }

  Future<void> fetchPhotoDetail(int photoId) async {
    if (state.isInitialized) return;

    try {
      final result = await _photoRepository.getPhotoDetail(photoId);

      if (result.isSuccess) {
        state = state.copyWith(
          isInitialized: true,
          photo: result.data
        );
      } else {
        ref.read(photoDetailEffectProvider.notifier).state = ShowToast("Failed to fetch photo details");
      }
    } catch (e) {
      ref.read(photoDetailEffectProvider.notifier).state = ShowToast("Error occurred: $e");
    }
  }

  Future<void> toggleLikePhoto(int photoId) async {
    try {
      final result = await (state.photo.isLiked
        ? _photoRepository.unlikePhoto(photoId)
        : _photoRepository.likePhoto(photoId));

      if (result.isSuccess) {
        state = state.copyWith(
            photo: state.photo.copyWith(
              isLiked: !state.photo.isLiked,
              likeCount: state.photo.isLiked
                  ? state.photo.likeCount - 1
                  : state.photo.likeCount + 1,
            )
        );
      } else {
        ref.read(photoDetailEffectProvider.notifier).state = ShowToast("Failed to toggle like");
      }
    } catch (e) {
      ref.read(photoDetailEffectProvider.notifier).state = ShowToast("Error occurred: $e");
    }
  }
}