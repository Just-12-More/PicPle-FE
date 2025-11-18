import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/response/hot_places_response.dart';
import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PicpleColors.white,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildHotPlaceSection()),
            SliverToBoxAdapter(child: _buildHashtagSection("#잔잔한")),
            SliverToBoxAdapter(child: _buildHashtagSection("#고요한"))
          ]
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2A3A5F), Color(0xFF09131E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      height: 280,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Picple",
                    style: PicpleTypography.title2.copyWith(
                        color: PicpleColors.white
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "주변의 사진 명소를\n찾아보세요!",
                    style: PicpleTypography.head2.copyWith(
                        color: PicpleColors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/img_picple_big_logo.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      )
    );
  }

  Widget _buildHotPlaceSection() {
    final hotPlaces = [
      HotPlace(
        order: 1,
        locationLabel: "경기도 수원시 팔달구 지동",
        photoCnt: 3,
        latitude: 37.2816337,
        longitude: 127.0222369,
      ),
      HotPlace(
        order: 2,
        locationLabel: "경기도 수원시 팔달구 행궁동",
        photoCnt: 32,
        latitude: 37.2841940,
        longitude: 127.0191077,
      ),
      HotPlace(
        order: 3,
        locationLabel: "서울특별시 강남구 역삼1동",
        photoCnt: 13,
        latitude: 37.5050333,
        longitude: 127.0412409,
      ),
      HotPlace(
        order: 4,
        locationLabel: "경기도 용인시 처인구 포곡읍",
        photoCnt: 212,
        latitude: 37.2933272,
        longitude: 127.2013221,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("오늘의 인기 장소"),
          const SizedBox(height: 10),
          ...hotPlaces.map(_buildHotPlaceItem),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            title,
            style: PicpleTypography.title1
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  Widget _buildHotPlaceItem(HotPlace place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.locationLabel,
                  style: PicpleTypography.title2,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.camera_alt, size: 16, color: PicpleColors.gray5),
                    const SizedBox(width: 4),
                    Text(
                      "새로운 사진 ${place.photoCnt}개",
                      style: PicpleTypography.body2SemiBold.copyWith(
                        color: PicpleColors.gray5
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: "https://picsum.photos/${300 + place.order}",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHashtagSection(String tag) {
    final imageUrls = List.generate(
        5, (i) => "https://picsum.photos/${300 + i}");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              tag,
              style: PicpleTypography.body2SemiBold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: imageUrls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
