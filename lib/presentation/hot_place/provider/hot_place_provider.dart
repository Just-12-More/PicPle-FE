import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/response/hot_places_response.dart';

final hotPlaceProvider = NotifierProvider<HotPlaceNotifier, List<HotPlace>>(
  () => HotPlaceNotifier(),
);

class HotPlaceNotifier extends Notifier<List<HotPlace>> {
  @override
  List<HotPlace> build() => const [];

  void setHotPlaces(List<HotPlace> hotPlaces) {
    state = List.unmodifiable(hotPlaces);
  }

  void clear() {
    state = const [];
  }
}
