import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/response/hot_places_response.dart';
import '../../../routes.dart';
import '../../hot_place/provider/hot_place_provider.dart';
import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';
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
  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(hotPlaceProvider.notifier).refresh(),
      ref.read(homeHashtagStateProvider.notifier).refreshHashtags(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HomeHashtagEffect?>(
      homeHashtagEffectProvider,
      (previous, effect) {
        if (effect is HomeHashtagShowToast) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(effect.message)),
          );
          ref.read(homeHashtagEffectProvider.notifier).state = null;
        }
      },
    );

    final hotPlaceState = ref.watch(hotPlaceProvider);
    final hashtagState = ref.watch(homeHashtagStateProvider);

    return Scaffold(
      backgroundColor: PicpleColors.white,
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildHotPlaceSection(hotPlaceState)),
              SliverToBoxAdapter(child: _buildHashtagSections(hashtagState)),
            ]
          ),
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
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 20.0),
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
              width: 160,
              height: 160
            ),
          ),
        ],
      )
    );
  }

  Widget _buildHotPlaceSection(HotPlaceState hotPlaceState) {
    final hotPlaces = hotPlaceState.hotPlaces;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("오늘의 인기 장소"),
          const SizedBox(height: 10),
          if (hotPlaceState.isLoading)
            const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (hotPlaces.isEmpty)
            SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  '아직 인기 장소 정보가 없습니다.',
                  style: PicpleTypography.body2.copyWith(
                    color: PicpleColors.gray5,
                  ),
                ),
              ),
            )
          else
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
              imageUrl: place.imgUrl,
              placeholder: (context, url) =>
                  Image.asset('assets/images/img_placeholder.png'),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/img_placeholder.png'),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHashtagSections(HomeHashtagState state) {
    Widget _buildContent() {
      if (state.isLoading && state.sections.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (state.sections.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(
            '현재 인기 태그가 없습니다.',
            style: PicpleTypography.body2.copyWith(color: PicpleColors.gray5),
          ),
        );
      }

      return Column(
        children: state.sections
            .map((section) => _buildHashtagSection(section))
            .toList(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '지금 인기 있는 태그',
              style: PicpleTypography.title1,
            ),
            ),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHashtagSection(HotTagSectionState section) {
    final tagLabel = '#${section.tag.name}';

    Widget _buildPhotoList() {
      if (section.isLoading && section.photos.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (section.photos.isEmpty) {
        return Center(
          child: Text(
            '사진이 아직 없습니다.',
            style: PicpleTypography.body2.copyWith(color: PicpleColors.gray5),
          ),
        );
      }

      return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: section.photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final photo = section.photos[index];
          return GestureDetector(
            onTap: () {
              context.push("${Routes.photoDetail.path}/${photo.id}");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: photo.imgUrl,
                placeholder: (context, url) =>
                    Image.asset('assets/images/img_placeholder.png'),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/img_placeholder.png'),
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10),
            child: Text(
              tagLabel,
              style: PicpleTypography.body1SemiBold.copyWith(
                color: PicpleColors.black,
              ),
            ),
          ),
          SizedBox(
            height: 96,
            child: _buildPhotoList(),
          ),
        ],
      ),
    );
  }
}
