import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/repository/photo_repository.dart';
import '../../../data/service_providers.dart';
import 'home_contract.dart';

final homeStateProvider = NotifierProvider<HomeNotifier, HomeState>(() => HomeNotifier());
final homeEffectProvider = StateProvider<HomeEffect?>((ref) => null);

class HomeNotifier extends Notifier<HomeState> {
  late final PhotoRepository _photoRepository;
  StreamSubscription<Position>? _positionSubscription;

  bool _hasFetchedInitialPhotos = false;
  double? _lastFetchedLatitude;
  double? _lastFetchedLongitude;

  @override
  HomeState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);

    _initLocationTracking();

    ref.onDispose(() {
      _positionSubscription?.cancel();
    });

    return HomeState();
  }

  Future<void> _initLocationTracking() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ref.read(homeEffectProvider.notifier).state =
          ShowToast("위치 권한이 필요합니다.");
      return;
    }

    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      setCurrentPosition(position.latitude, position.longitude);
    });
  }

  void setCurrentPosition(double latitude, double longitude) {
    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
    );

    if (!_hasFetchedInitialPhotos) {
      _hasFetchedInitialPhotos = true;
      _lastFetchedLatitude = latitude;
      _lastFetchedLongitude = longitude;
      fetchGeoPhotos(latitude, longitude);

      ref.read(homeEffectProvider.notifier).state = MoveCamera(latitude, longitude);
      return;
    }

    if (_shouldRefresh(latitude, longitude)) {
      _lastFetchedLatitude = latitude;
      _lastFetchedLongitude = longitude;
      fetchGeoPhotos(latitude, longitude);

      if (state.isCameraLockedOnUser) {
        ref.read(homeEffectProvider.notifier).state = MoveCamera(latitude, longitude);
      }
    }
  }

  bool _shouldRefresh(double lat, double lng) {
    if (_lastFetchedLatitude == null || _lastFetchedLongitude == null) {
      return true;
    }

    final latDiff = (lat - _lastFetchedLatitude!).abs();
    final lngDiff = (lng - _lastFetchedLongitude!).abs();

    return latDiff >= 0.02 || lngDiff >= 0.02;
  }

  void toggleCameraLock() {
    final newLockState = !state.isCameraLockedOnUser;
    state = state.copyWith(isCameraLockedOnUser: newLockState);
  }

  Future<void> fetchGeoPhotos(
    double latitude,
    double longitude,
  ) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _photoRepository.getGeoPhotos(
        latitude,
        longitude
      );

      if (result.isSuccess) {
        state = state.copyWith(
          photos: result.data!.photos
        );
      } else {
        ref.read(homeEffectProvider.notifier).state = ShowToast("사진을 불러오는 데 실패했습니다.");
      }
    } catch (e) {
      ref.read(homeEffectProvider.notifier).state = ShowToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}