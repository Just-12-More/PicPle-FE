import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _buildMap()),
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
}