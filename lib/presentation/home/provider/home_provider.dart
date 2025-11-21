import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/response/tagged_photos_response.dart';
import '../../../data/repository/tag_repository.dart';
import '../../../data/service_providers.dart';
import 'home_contract.dart';

final homeHashtagStateProvider =
    NotifierProvider.autoDispose<HomeHashtagNotifier, HomeHashtagState>(
  () => HomeHashtagNotifier(),
);

final homeHashtagEffectProvider =
    StateProvider.autoDispose<HomeHashtagEffect?>((ref) => null);

class HomeHashtagNotifier extends AutoDisposeNotifier<HomeHashtagState> {
  late final TagRepository _tagRepository;

  @override
  HomeHashtagState build() {
    _tagRepository = ref.watch(tagRepositoryProvider);
    Future.microtask(_loadHotTags);
    return const HomeHashtagState(isLoading: true);
  }

  Future<void> refreshHashtags() async {
    await _loadHotTags();
  }

  Future<void> _loadHotTags() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _tagRepository.getHotTags();

      if (response.isSuccess && response.data != null) {
        final hotTags = response.data!.tags;
        final sections = hotTags
            .map(
              (tag) => HotTagSectionState(
                tag: tag,
                photos: const <TaggedPhoto>[],
                isLoading: true,
              ),
            )
            .toList();

        state = state.copyWith(
          isLoading: false,
          sections: sections,
        );

        if (hotTags.isEmpty) {
          return;
        }

        await Future.wait(
          hotTags.map((tag) => _loadPhotosForTag(tag.id)),
        );
      } else {
        state = state.copyWith(isLoading: false);
        _emitToast('인기 태그를 불러오지 못했습니다.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      _emitToast('인기 태그 조회 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> _loadPhotosForTag(int tagId) async {
    try {
      final response = await _tagRepository.getPhotosByTagId(tagId);
      final photos = response.data?.photos ?? const <TaggedPhoto>[];

      if (response.isSuccess) {
        _updateSection(tagId, photos: photos, isLoading: false);
      } else {
        _updateSection(tagId, isLoading: false);
        _emitToast('태그 사진을 불러오지 못했습니다.');
      }
    } catch (e) {
      _updateSection(tagId, isLoading: false);
      _emitToast('태그 사진 조회 중 오류가 발생했습니다: $e');
    }
  }

  void _updateSection(
    int tagId, {
    List<TaggedPhoto>? photos,
    bool? isLoading,
  }) {
    final updatedSections = state.sections.map((section) {
      if (section.tag.id != tagId) return section;
      return section.copyWith(
        photos: photos ?? section.photos,
        isLoading: isLoading ?? section.isLoading,
      );
    }).toList();

    state = state.copyWith(sections: updatedSections);
  }

  void _emitToast(String message) {
    ref.read(homeHashtagEffectProvider.notifier).state =
        HomeHashtagShowToast(message);
  }
}
