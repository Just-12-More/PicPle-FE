import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

import '../../../core/util/naver_map_utils.dart';
import '../../theme/picple_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen(); // 화면 전환 또는 포함 여부에 따라 조정
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NaverMapController? _mapController;
  bool _isTracking = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _buildMap(),
          SearchFromHereButton(
            onTap: () {
              // 검색 기능 구현
            },
          ),
          LocationToggleButton(
            isTracking: _isTracking,
            onTap: () {
              setState(() {
                _isTracking = !_isTracking;
              });
            },
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
        await _addMyLocationMarker();
        await _addRandomMarkersAroundSeoul();
      },
    );
  }

  Future<void> _addMyLocationMarker() async {
    if (_mapController == null) return;

    final myPositionIcon = await NOverlayImage.fromWidget(
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

    // 마커 추가
    final marker = NMarker(
      id: 'my_location',
      position: const NLatLng(37.5665, 126.978),
      icon: myPositionIcon,
    );

    // 반경 원 추가
    final circle = NCircleOverlay(
      id: 'my_radius',
      center: const NLatLng(37.5665, 126.978),
      radius: 500, // meters
      color: PicpleColors.primary1.withAlpha((0.2 * 255).toInt()),
    );

    // 지도에 표시
    _mapController!
      ..addOverlay(circle)
      ..addOverlay(marker)
      ..updateCamera(NCameraUpdate.scrollAndZoomTo(
        target: const NLatLng(37.5665, 126.978),
        zoom: 14,
      ));
  }

  Future<void> _addRandomMarkersAroundSeoul() async {
    if (_mapController == null) return;

    const centerLat = 37.5665;
    const centerLng = 126.9780;
    const markerCount = 50;

    final rand = Random();

    for (int i = 0; i < markerCount; i++) {
      final randomLatOffset = (rand.nextDouble() - 0.5) * 0.01; // ±0.005
      final randomLngOffset = (rand.nextDouble() - 0.5) * 0.01;

      final imageId = 200 + i;
      final imageUrl = 'https://picsum.photos/id/$imageId/300/300';

      addMarkerWithPlaceholderImage(
          controller: _mapController!,
          id: 'random_marker_$i',
          position: NLatLng(
            centerLat + randomLatOffset,
            centerLng + randomLngOffset,
          ),
          imageUrl: imageUrl
      );
    }
  }
}

class SearchFromHereButton extends StatelessWidget {
  final VoidCallback onTap;

  const SearchFromHereButton({
    super.key,
    required this.onTap,
  });

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
                  style: PicpleTypography.body1SemiBold.copyWith(
                    color: PicpleColors.primary1,
                  ),
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

  const LocationToggleButton({
    super.key,
    required this.isTracking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isTracking ? PicpleColors.primary1: PicpleColors.white;
    final iconColor = isTracking ? PicpleColors.white : PicpleColors.primary1;

    return Positioned(
      bottom: 24,
      right: 24,
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: PicpleColors.white,
                width: 2
              )
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/ic_location.svg",
                width: 36,
                height: 36,
                colorFilter: ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn
                )
              ),
            ),
          ),
        ),
      )
    );
  }
}