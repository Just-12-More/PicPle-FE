import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:picple/core/util/naver_map_utils.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

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
  NCircleOverlay? _myLocationCircle;

  @override
  void initState() {
    super.initState();
  }

  void _startTracking() async {
    final hasPermission = await Geolocator.requestPermission();
    if (hasPermission == LocationPermission.denied ||
        hasPermission == LocationPermission.deniedForever) {
      return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) async {
      if (_isTracking && _mapController != null) {
        await _updateMyLocationMarker(position);
      }
    });
  }

  Future<void> _updateMyLocationMarker(Position position) async {
    final newPosition = NLatLng(position.latitude, position.longitude);

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

    _mapController!.deleteOverlay(_myLocationMarker!.info);
    _mapController!.deleteOverlay(_myLocationCircle!.info);

    _myLocationMarker = NMarker(
      id: 'my_location',
      position: newPosition,
      icon: markerIcon,
    );

    _myLocationCircle = NCircleOverlay(
      id: 'my_radius',
      center: newPosition,
      radius: 500,
      color: PicpleColors.primary1.withAlpha((0.2 * 255).toInt()),
    );

    _mapController!
      ..addOverlay(_myLocationMarker!)
      ..addOverlay(_myLocationCircle!)
      ..updateCamera(NCameraUpdate.scrollAndZoomTo(
        target: newPosition,
        zoom: 14,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _buildMap(),
          SearchFromHereButton(onTap: () {}),
          LocationToggleButton(
            isTracking: _isTracking,
            onTap: () => setState(() => _isTracking = !_isTracking),
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
      ),
      onMapReady: (controller) async {
        _mapController = controller;
        await _addRandomMarkersAroundSeoul();
      },
    );
  }

  Future<void> _addRandomMarkersAroundSeoul() async {
    if (_mapController == null) return;

    const centerLat = 37.5665;
    const centerLng = 126.9780;
    const markerCount = 50;

    final rand = Random();

    for (int i = 0; i < markerCount; i++) {
      final randomLatOffset = (rand.nextDouble() - 0.5) * 0.01;
      final randomLngOffset = (rand.nextDouble() - 0.5) * 0.01;

      final imageId = 200 + i;
      final imageUrl = 'https://picsum.photos/id/$imageId/300/300';

      addMarkerWithPlaceholderImage(
        controller: _mapController!,
        id: 'random_marker_$i',
        position: NLatLng(centerLat + randomLatOffset, centerLng + randomLngOffset),
        imageUrl: imageUrl,
      );
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
        child: InkWell(
          borderRadius: BorderRadius.circular(42),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(42),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '현위치에서 검색',
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
      ),
    );
  }
}

class LocationToggleButton extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onTap;

  const LocationToggleButton({super.key, required this.isTracking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isTracking ? PicpleColors.primary1 : PicpleColors.white;
    final iconColor = isTracking ? PicpleColors.white : PicpleColors.primary1;

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
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: PicpleColors.white, width: 2),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/ic_location.svg",
              width: 36,
              height: 36,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
