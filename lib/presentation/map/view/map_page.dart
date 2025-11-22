import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

import '../../../core/util/naver_map_utils.dart';
import '../../../data/model/response/hot_places_response.dart';
import '../../../data/model/response/nearby_photos_response.dart';
import '../../../routes.dart';
import '../../hot_place/provider/hot_place_provider.dart';
import '../provider/map_contract.dart';
import '../provider/map_provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapScreen();
  }
}

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  NaverMapController? _mapController;
  NMarker? _myLocationMarker;
  final List<String> _renderedPhotoIds = [];
  final Map<String, NMarker> _hotPlaceMarkers = {};

  static const int _photoMarkerZIndex = 0;
  static const int _hotPlaceMarkerZIndex = 10;
  static const int _myLocationMarkerZIndex = 20;

  static const int _photoMarkerGlobalZIndex = 200000;
  static const int _hotPlaceMarkerGlobalZIndex = 200010;
  static const int _myLocationMarkerGlobalZIndex = 200020;

  @override
  Widget build(BuildContext context) {
    ref.listen<List<PhotoData>>(
      mapStateProvider.select((state) => state.photos),
      (previous, next) {
        _renderPhotoMarkers(next);
      },
    );

    ref.listen<List<HotPlace>>(
      hotPlaceProvider.select((state) => state.hotPlaces),
      (previous, next) {
        _renderHotPlaceMarkers(next);
      },
    );

    ref.listen<({double? latitude, double? longitude})>(
      mapStateProvider.select(
        (state) => (latitude: state.userLatitude, longitude: state.userLongitude),
      ),
      (previous, next) {
        final hasPosition = next.latitude != null && next.longitude != null;
        if (!hasPosition) return;

        _updateMyLocationMarker(next.latitude!, next.longitude!);
      },
    );

    ref.listen<HomeEffect?>(mapEffectProvider, (previous, next) {
      if (next == null) return;

      switch (next) {
        case NavigateTo():
          context.push(next.route);
          break;
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
        case MoveCamera():
          if (_mapController != null) {
            _mapController!.updateCamera(
              NCameraUpdate.scrollAndZoomTo(
                target: NLatLng(next.latitude, next.longitude),
                zoom: 14,
              ),
            );
          }
          break;
      }

      ref.read(mapEffectProvider.notifier).state = null;
    });

    return SafeArea(
      child: Stack(
        children: [
          _buildMap(),
          SearchFromHereButton(onTap: () {
            if (_mapController == null) return;

            final latitude = _mapController!.nowCameraPosition.target.latitude;
            final longitude = _mapController!.nowCameraPosition.target.longitude;

            ref.read(mapStateProvider.notifier).fetchGeoPhotos(latitude, longitude);
          }),
          MoveToMyLocationButton(
            onTap: () => ref.read(mapStateProvider.notifier).moveToMyLocation()
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return NaverMap(
      options: const NaverMapViewOptions(
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false,
        rotationGesturesEnable: true,
        scrollGesturesEnable: true,
        zoomGesturesEnable: true,
        minZoom: 10,
      ),
      clusterOptions: NaverMapClusteringOptions(
          mergeStrategy: const NClusterMergeStrategy(
            maxMergeableScreenDistance: 50,
          ),
          clusterMarkerBuilder: (info, clusterMarker) {
            clusterMarker.setIcon(NOverlayImage.fromAssetImage("assets/images/img_cluster_marker.png"));
            clusterMarker.setSize(const Size(50, 50));
            clusterMarker.setIsFlat(true);
            clusterMarker.setCaption(NOverlayCaption(
                text: info.size.toString(),
                textSize: 24.0,
                color: PicpleColors.black));
          }),
      onMapReady: (controller) async {
        _mapController = controller;
        _renderedPhotoIds.clear();

        final currentState = ref.read(mapStateProvider);
        _renderPhotoMarkers(currentState.photos);
        _renderHotPlaceMarkers(ref.read(hotPlaceProvider).hotPlaces);

        final latitude = currentState.userLatitude;
        final longitude = currentState.userLongitude;
        if (latitude != null && longitude != null) {
          await _updateMyLocationMarker(latitude, longitude);
        }
      },
      onCameraIdle: () {
        final camera = _mapController!.nowCameraPosition;

        ref.read(mapStateProvider.notifier).setCameraPosition(
          camera.target.latitude,
          camera.target.longitude,
          camera.zoom.toInt(),
        );
      },
    );
  }

  Future<void> _updateMyLocationMarker(
    double latitude,
    double longitude
  ) async {
    if (_mapController == null) return;

    final newPosition = NLatLng(latitude, longitude);

    final markerIcon = await NOverlayImage.fromWidget(
      context: context,
      widget: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: PicpleColors.white,
        ),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: PicpleColors.primary1,
            ),
          ),
        ),
      ),
      size: const Size(20, 20),
    );

    if (_myLocationMarker != null) {
      _mapController!.deleteOverlay(_myLocationMarker!.info);
    }

    _myLocationMarker = NMarker(
      id: 'my_location',
      position: newPosition,
      icon: markerIcon,
    );

    _myLocationMarker!
      ..setZIndex(_myLocationMarkerZIndex)
      ..setGlobalZIndex(_myLocationMarkerGlobalZIndex);

    _mapController!.addOverlay(_myLocationMarker!);
  }

  void _renderPhotoMarkers(List<PhotoData> photos) {
    if (_mapController == null) return;

    for (final photo in photos) {
      final markerId = 'photo_${photo.id}';
      if (_renderedPhotoIds.contains(markerId)) continue;

      addMarkerWithImage(
        controller: _mapController!,
        id: markerId,
        position: NLatLng(photo.latitude, photo.longitude),
        imageUrl: photo.imgUrl,
        zIndex: _photoMarkerZIndex,
        globalZIndex: _photoMarkerGlobalZIndex,
        onTap: () {
          context.push(
            "${Routes.photoList.path}/${photo.id}",
          );
        }
      );

      _renderedPhotoIds.add(markerId);
    }
  }

  void _renderHotPlaceMarkers(List<HotPlace> places) {
    final controller = _mapController;
    if (controller == null) return;

    for (final marker in _hotPlaceMarkers.values) {
      controller.deleteOverlay(marker.info);
    }
    _hotPlaceMarkers.clear();

    for (final place in places) {
      final markerId = _hotPlaceMarkerId(place);
      final marker = NMarker(
        id: markerId,
        position: NLatLng(place.latitude, place.longitude),
        icon: const NOverlayImage.fromAssetImage('assets/images/img_hotplace.png'),
        size: const Size(60, 60),
      );

      marker
        ..setZIndex(_hotPlaceMarkerZIndex)
        ..setGlobalZIndex(_hotPlaceMarkerGlobalZIndex);

      controller.addOverlay(marker);
      _hotPlaceMarkers[markerId] = marker;
    }
  }

  String _hotPlaceMarkerId(HotPlace place) {
    final labelHash = place.locationLabel.hashCode;
    return 'hot_place_${place.order}_$labelHash';
  }
}

class SearchFromHereButton extends StatelessWidget {
  final VoidCallback onTap;
  const SearchFromHereButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Center(
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(42),
              ),
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return PicpleColors.gray2;
                }
                return null;
              },
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '현 지도에서 검색',
                style: PicpleTypography.body1SemiBold.copyWith(color: PicpleColors.primary1),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                'assets/icons/ic_refresh.svg',
                width: 12,
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoveToMyLocationButton extends StatelessWidget {
  final VoidCallback onTap;

  const MoveToMyLocationButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: PicpleColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: PicpleColors.white, width: 2),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/ic_location.svg",
              width: 36,
              height: 36,
              colorFilter: const ColorFilter.mode(PicpleColors.primary1, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
