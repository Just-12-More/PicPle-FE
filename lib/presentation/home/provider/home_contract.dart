import '../../../data/model/response/hot_tags_response.dart';
import '../../../data/model/response/tagged_photos_response.dart';

class HomeHashtagState {
  final bool isLoading;
  final List<HotTagSectionState> sections;

  const HomeHashtagState({
    this.isLoading = false,
    this.sections = const <HotTagSectionState>[],
  });

  HomeHashtagState copyWith({
    bool? isLoading,
    List<HotTagSectionState>? sections,
  }) {
    return HomeHashtagState(
      isLoading: isLoading ?? this.isLoading,
      sections: sections ?? this.sections,
    );
  }
}

class HotTagSectionState {
  final HotTag tag;
  final List<TaggedPhoto> photos;
  final bool isLoading;

  const HotTagSectionState({
    required this.tag,
    this.photos = const <TaggedPhoto>[],
    this.isLoading = true,
  });

  HotTagSectionState copyWith({
    HotTag? tag,
    List<TaggedPhoto>? photos,
    bool? isLoading,
  }) {
    return HotTagSectionState(
      tag: tag ?? this.tag,
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class HomeHashtagEffect {}

class HomeHashtagShowToast extends HomeHashtagEffect {
  final String message;

  HomeHashtagShowToast(this.message);
}
