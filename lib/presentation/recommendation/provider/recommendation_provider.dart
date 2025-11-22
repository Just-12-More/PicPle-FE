import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/photo_repository.dart';
import '../../../data/service_providers.dart';
import '../model/recommendation_photo.dart';

final recommendationStateProvider =
    NotifierProvider.autoDispose<RecommendationNotifier, RecommendationState>(
  () => RecommendationNotifier(),
);

final recommendationEffectProvider =
    StateProvider.autoDispose<RecommendationEffect?>((ref) => null);

class RecommendationState {
  final bool isLoading;
  final List<RecommendationPhoto> photos;

  const RecommendationState({
    this.isLoading = false,
    this.photos = const <RecommendationPhoto>[],
  });

  RecommendationState copyWith({
    bool? isLoading,
    List<RecommendationPhoto>? photos,
  }) {
    return RecommendationState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
    );
  }
}

abstract class RecommendationEffect {}

class RecommendationShowSnackBar extends RecommendationEffect {
  final String message;

  RecommendationShowSnackBar(this.message);
}

class RecommendationNotifier extends AutoDisposeNotifier<RecommendationState> {
  late final PhotoRepository _photoRepository;

  @override
  RecommendationState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);
    return const RecommendationState(isLoading: false);
  }

  Future<void> fetchRecommendations(List<int> tagIds) async {
    if (tagIds.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        photos: const <RecommendationPhoto>[],
      );
      _showError('추천할 태그 정보가 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final response = await _photoRepository.getRecommendedPhotos(tagIds);
      if (response.isSuccess && response.data != null) {
        final items = response.data!.photos
            .map(
              (photo) => RecommendationPhoto(
                id: photo.id,
                imageUrl: photo.imgUrl,
                tags: photo.tags,
              ),
            )
            .toList();
        state = state.copyWith(
          isLoading: false,
          photos: items,
        );
      } else {
        state = state.copyWith(isLoading: false);
        _showError(response.error?.message ?? '추천 사진을 가져오지 못했습니다.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      _showError('추천 사진 조회 중 오류가 발생했습니다: $e');
    }
  }

  void _showError(String message) {
    ref.read(recommendationEffectProvider.notifier).state =
        RecommendationShowSnackBar(message);
  }
}
