import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/repository/photo_repository.dart';
import 'package:picple/presentation/shared/photo_detail/provider/photo_detail_contract.dart';

import '../../../../data/service_providers.dart';

final photoDetailStateProvider = NotifierProvider<PhotoDetailNotifier, PhotoDetailState>(() => PhotoDetailNotifier());
final photoDetailEffectProvider = StateProvider<PhotoDetailEffect?>((ref) => null);

class PhotoDetailNotifier extends Notifier<PhotoDetailState> {
  late final PhotoRepository _photoRepository;

  @override
  PhotoDetailState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);
    return PhotoDetailState();
  }

  Future<void> fetchPhotoDetail(int photoId) async {
    state = state.copyWith(isLoading: true);

    /*try {
      final result = await _photoRepository.getPhotoDetail(photoId);

      if (result.isSuccess) {
        state = state.copyWith(photo: result.data);
      } else {
        ref.read(photoDetailEffectProvider.notifier).state = ShowToast("Failed to fetch photo details");
      }
    } catch (e) {
      ref.read(photoDetailEffectProvider.notifier).state = ShowToast("Error occurred: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
     */
  }
}