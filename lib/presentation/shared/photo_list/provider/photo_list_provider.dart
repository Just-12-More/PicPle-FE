import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/repository/photo_repository.dart';
import 'package:picple/presentation/shared/photo_list/provider/photo_list_contract.dart';

import '../../../../data/service_providers.dart';

final photoListStateProvider = NotifierProvider<PhotoListNotifier, PhotoListState>(() => PhotoListNotifier());
final photoListEffectProvider = StateProvider<PhotoListEffect?>((ref) => null);

class PhotoListNotifier extends Notifier<PhotoListState> {
  late final PhotoRepository _photoRepository;

  int? _lastCenterPhotoId;

  @override
  PhotoListState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);
    return PhotoListState();
  }

  Future<void> fetchPhotoList(int centerPhotoId) async {
    if (state.isInitialized && centerPhotoId == _lastCenterPhotoId) return;
    if (centerPhotoId != _lastCenterPhotoId) {
      state = state.copyWith(isInitialized: false, address: null, photos: []);
    }

    try {
      final result = await _photoRepository.getNearbyPhotos(centerPhotoId);

      if (result.isSuccess) {
        state = state.copyWith(
          isInitialized: true,
          address: result.data!.address,
          photos: [
            result.data!.centerPhoto,
            ...result.data!.nearbyPhotos,
          ]
        );
        _lastCenterPhotoId = centerPhotoId;
      } else {
        ref.read(photoListEffectProvider.notifier).state = ShowToast("Failed to fetch photos");
      }
    } catch (e) {
      ref.read(photoListEffectProvider.notifier).state = ShowToast("Error occurred: $e");
    }
  }

  Future<void> toggleLikePhoto(int photoId) async {
    try {
      final targetPhoto = state.photos.firstWhere((photo) => photo.id == photoId);

      final result = await (targetPhoto.isLiked
          ? _photoRepository.unlikePhoto(photoId)
          : _photoRepository.likePhoto(photoId));

      if (result.isSuccess) {
        state = state.copyWith(
          photos: state.photos.map((photo) {
            return photo.id == photoId
                ? photo.copyWith(
                    isLiked: !photo.isLiked,
                    likeCount: photo.isLiked
                        ? photo.likeCount - 1
                        : photo.likeCount + 1)
                : photo;
          }).toList(),
        );
      } else {
        ref.read(photoListEffectProvider.notifier).state = ShowToast("Failed to toggle like");
      }
    } catch (e) {
      ref.read(photoListEffectProvider.notifier).state = ShowToast("Error occurred: $e");
    }
  }
}