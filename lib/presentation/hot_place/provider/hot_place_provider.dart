import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/response/hot_places_response.dart';
import '../../../data/service_providers.dart';

final hotPlaceProvider = NotifierProvider<HotPlaceNotifier, List<HotPlace>>(
  () => HotPlaceNotifier(),
);

class HotPlaceNotifier extends Notifier<List<HotPlace>> {
  @override
  List<HotPlace> build() {
    _loadInitialHotPlaces();
    return const [];
  }

  Future<void> _loadInitialHotPlaces() async {
    try {
      final response = await ref.read(photoRepositoryProvider).getHotPlacesTop10();
      final data = response.data;
      if (response.isSuccess && data != null) {
        state = List.unmodifiable(data.hotPlaces);
      }
    } catch (e, stack) {
      log('Failed to load hot places: $e', stackTrace: stack);
    }
  }

  Future<void> refresh() => _loadInitialHotPlaces();

  void setHotPlaces(List<HotPlace> hotPlaces) {
    state = List.unmodifiable(hotPlaces);
  }

  void clear() {
    state = const [];
  }
}
