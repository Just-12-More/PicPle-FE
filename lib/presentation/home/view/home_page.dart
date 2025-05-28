import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

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

  Future<void> _updateMyLocationMarker(double latitude, double longitude) async {
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

    _mapController!
      ..addOverlay(_myLocationMarker!)
      ..updateCamera(NCameraUpdate.scrollAndZoomTo(
        target: newPosition,
        zoom: 14,
      ));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeStateProvider);

    ref.listen(
      homeStateProvider.select((state) => (state.latitude, state.longitude)),
          (previous, next) {
        final (lat, lng) = next;
        if (lat != null && lng != null && _mapController != null) {
          _updateMyLocationMarker(lat, lng);
        }
      },
    );

    ref.listen<HomeEffect?>(homeEffectProvider, (previous, next) {
      if (next == null) return;

      switch (next) {
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
      }

      ref.read(homeEffectProvider.notifier).state = null;
    });

    return SafeArea(
      child: Stack(
        children: [
          _buildMap(),
          SearchFromHereButton(onTap: () {}),
          LocationToggleButton(
            isCameraLockedOnUser: state.isCameraLockedOnUser,
            onTap: () =>
                ref.read(homeStateProvider.notifier).toggleCameraLock(),
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
      },
    );
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
  final bool isCameraLockedOnUser;
  final VoidCallback onTap;

  const LocationToggleButton({super.key, required this.isCameraLockedOnUser, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isCameraLockedOnUser ? PicpleColors.primary1 : PicpleColors.white;
    final iconColor = isCameraLockedOnUser ? PicpleColors.white : PicpleColors.primary1;

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
