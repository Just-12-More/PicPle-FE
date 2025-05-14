import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMap()),
          ],
        ),
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
        await _addMarkersAndPath();
      },
    );
  }

  Future<void> _addMarkersAndPath() async {
    if (_mapController == null) return;

    // 마커, 경로 등을 추가하는 로직 작성 예시
    final marker = NMarker(
      id: 'marker_1',
      position: const NLatLng(37.5665, 126.9780), // 서울시청 좌표 예시
    );

    _mapController!.addOverlay(marker);
  }
}