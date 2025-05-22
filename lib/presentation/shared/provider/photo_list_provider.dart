import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/repository/photo_repository.dart';
import 'package:picple/presentation/shared/provider/photo_list_contract.dart';

import '../../../data/service_providers.dart';

final photoListStateProvider = NotifierProvider<PhotoListNotifier, PhotoListState>(() => PhotoListNotifier());
final photoListEffectProvider = StateProvider<PhotoListEffect?>((ref) => null);

class PhotoListNotifier extends Notifier<PhotoListState> {
  late final PhotoRepository _photoRepository;

  @override
  PhotoListState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);
    return PhotoListState();
  }

  Future<void> fetchPhotoList() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _photoRepository.getNearbyPhotos(37.5665, 126.978);

      if (result.isSuccess) {
        state = state.copyWith(
          address: result.data!.address,
          photos: [
            result.data!.centerPhoto,
            ...result.data!.nearbyPhotos,
          ]
        );
      } else {
        ref.read(photoListEffectProvider.notifier).state = ShowToast("Failed to fetch photos");
      }
    } catch (e) {
      ref.read(photoListEffectProvider.notifier).state = ShowToast("Error occurred: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}