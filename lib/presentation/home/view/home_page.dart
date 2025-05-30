import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

import '../../../core/util/naver_map_utils.dart';
import '../../../data/model/response/nearby_photos_response.dart';
import '../provider/home_contract.dart';
import '../provider/home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  NaverMapController? _mapController;
  NMarker? _myLocationMarker;
  final List<String> _renderedPhotoIds = [];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _renderPhotoMarkers(state.photos);
      if (state.userLatitude != null && state.userLongitude != null) {
        _updateMyLocationMarker(state.userLatitude!, state.userLongitude!);
      } else {
        log('No initial location data available');
      }
    });

    ref.listen<HomeEffect?>(homeEffectProvider, (previous, next) {
      if (next == null) return;

      switch (next) {
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

      ref.read(homeEffectProvider.notifier).state = null;
    });

    return SafeArea(
      child: Stack(
        children: [
          _buildMap(),
          SearchFromHereButton(onTap: () {
            if (_mapController == null) return;

            final latitude = _mapController!.nowCameraPosition.target.latitude;
            final longitude = _mapController!.nowCameraPosition.target.longitude;

            ref.read(homeStateProvider.notifier).fetchGeoPhotos(latitude, longitude);
          }),
          MoveToMyLocationButton(
            onTap: () => ref.read(homeStateProvider.notifier).moveToMyLocation()
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
      onMapReady: (controller) async {
        _mapController = controller;
      },
      onCameraIdle: () {
        final camera = _mapController!.nowCameraPosition;

        ref.read(homeStateProvider.notifier).setCameraPosition(
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

    _mapController!.addOverlay(_myLocationMarker!);
  }

  void _renderPhotoMarkers(List<PhotoData> photos){
    for (final photo in photos) {
      final markerId = 'photo_${photo.id}';
      if (_renderedPhotoIds.contains(markerId)) continue;

      addMarkerWithPlaceholderImage(
        controller: _mapController!,
        id: markerId,
        position: NLatLng(photo.latitude, photo.longitude),
        imageUrl: photo.imgUrl,
      );

      _renderedPhotoIds.add(markerId);
    }
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
