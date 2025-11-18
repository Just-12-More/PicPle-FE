import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';
import 'package:picple/routes.dart';

import '../../../data/model/response/my_photos_response.dart';
import '../provider/profile_contract.dart';
import '../provider/profile_notifier.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      profileStateProvider.select((state) => state.isLoading),
    );

    ref.listen<ProfileEffect?>(profileEffectProvider, (previous, next) {
      if (next == null) return;

      switch (next) {
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
        case NavigateTo():
          context.push(next.route);
          break;
      }

      ref.read(profileEffectProvider.notifier).state = null;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('마이페이지', style: PicpleTypography.title1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => ref
                .read(profileStateProvider.notifier)
                .navigateTo("${Routes.profile.path}/${Routes.setting.path}"),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildProfileContent(ref),
          if (isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.transparent,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
      backgroundColor: PicpleColors.white,
    );
  }

  Widget _buildProfileContent(WidgetRef ref) {
    final profileInfo = ref.watch(
      profileStateProvider.select(
        (state) => (image: state.profileImage, nickname: state.nickname),
      ),
    );
    final myPhotos = ref.watch(
      profileStateProvider.select((state) => state.myPhotos),
    );
    final likedPhotos = ref.watch(
      profileStateProvider.select((state) => state.myLikedPhotos),
    );

    final selectedPhotos = _tabController.index == 0 ? myPhotos : likedPhotos;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(profileStateProvider.notifier).refreshState();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            ClipOval(
              child: CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: profileInfo.image ?? '',
                placeholder: (context, url) =>
                    Image.asset('assets/images/img_profile_placeholder.png'),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/img_profile_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profileInfo.nickname ?? '닉네임 없음',
              style: PicpleTypography.title2,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: PicpleColors.gray2)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: PicpleColors.primary1,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: PicpleColors.primary1, width: 2),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: PicpleColors.primary1,
                unselectedLabelColor: PicpleColors.gray5,
                labelStyle: PicpleTypography.body1SemiBold,
                tabs: const [
                  Tab(text: '내가 찍은 사진'),
                  Tab(text: '좋아요한 사진'),
                ],
              ),
            ),
            _buildPhotoGrid(selectedPhotos),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<SimplePhotoData> photos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            ref.read(profileStateProvider.notifier).navigateTo(
              "${Routes.photoDetail.path}/${photos[index].id}",
            );
          },
          child: Image.network(photos[index].imgUrl, fit: BoxFit.cover)
        );
      },
    );
  }
}
