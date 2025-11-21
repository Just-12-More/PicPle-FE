import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/response/hot_places_response.dart';
import '../../../data/service_providers.dart';

class HotPlaceState {
  final bool isLoading;
  final List<HotPlace> hotPlaces;

  const HotPlaceState({
    this.isLoading = false,
    this.hotPlaces = const <HotPlace>[],
  });

  HotPlaceState copyWith({
    bool? isLoading,
    List<HotPlace>? hotPlaces,
  }) {
    return HotPlaceState(
      isLoading: isLoading ?? this.isLoading,
      hotPlaces: hotPlaces ?? this.hotPlaces,
    );
  }
}

final hotPlaceProvider = NotifierProvider<HotPlaceNotifier, HotPlaceState>(
  () => HotPlaceNotifier(),
);

class HotPlaceNotifier extends Notifier<HotPlaceState> {
  @override
  HotPlaceState build() {
    _loadInitialHotPlaces();
    return const HotPlaceState(isLoading: true);
  }

  Future<void> _loadInitialHotPlaces() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref.read(photoRepositoryProvider).getHotPlacesTop10();
      final data = response.data;
      if (response.isSuccess && data != null) {
        state = state.copyWith(
          isLoading: false,
          hotPlaces: List.unmodifiable(data.hotPlaces),
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e, stack) {
      log('Failed to load hot places: $e', stackTrace: stack);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() => _loadInitialHotPlaces();

  void setHotPlaces(List<HotPlace> hotPlaces) {
    state = state.copyWith(
      isLoading: false,
      hotPlaces: List.unmodifiable(hotPlaces),
    );
  }

  void clear() {
    state = const HotPlaceState(isLoading: false, hotPlaces: []);
  }
}
