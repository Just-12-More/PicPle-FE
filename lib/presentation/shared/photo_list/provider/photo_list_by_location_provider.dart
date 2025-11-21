import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repository/photo_repository.dart';
import '../../../../data/service_providers.dart';
import 'photo_list_contract.dart';

final photoListByLocationStateProvider =
    NotifierProvider.autoDispose<LocationPhotoListNotifier, PhotoListState>(
  () => LocationPhotoListNotifier(),
);

final photoListByLocationEffectProvider =
    StateProvider.autoDispose<PhotoListEffect?>((ref) => null);

class LocationPhotoListNotifier extends AutoDisposeNotifier<PhotoListState> {
  late final PhotoRepository _photoRepository;
  String? _currentLocation;

  @override
  PhotoListState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);
    return PhotoListState();
  }

  Future<void> fetchPhotosByLocation(String location) async {
    if (state.isInitialized && _currentLocation == location) return;
    _currentLocation = location;

    try {
      final result = await _photoRepository.getPhotosByLocation(location);

      if (result.isSuccess && result.data != null) {
        state = state.copyWith(
          isInitialized: true,
          address: location,
          photos: result.data!.photos,
        );
      } else {
        ref.read(photoListByLocationEffectProvider.notifier).state =
            ShowToast("Failed to fetch photos");
      }
    } catch (e) {
      ref.read(photoListByLocationEffectProvider.notifier).state =
          ShowToast("Error occurred: $e");
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
                    likeCount:
                        photo.isLiked ? photo.likeCount - 1 : photo.likeCount + 1)
                : photo;
          }).toList(),
        );
      } else {
        ref.read(photoListByLocationEffectProvider.notifier).state =
            ShowToast("Failed to toggle like");
      }
    } catch (e) {
      ref.read(photoListByLocationEffectProvider.notifier).state =
          ShowToast("Error occurred: $e");
    }
  }
}
