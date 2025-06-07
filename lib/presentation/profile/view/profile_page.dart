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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileStateProvider);

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
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileContent(state),
    );
  }

  Widget _buildProfileContent(ProfileState state) {
    final state = ref.watch(profileStateProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(profileStateProvider.notifier).refreshState();
      },
      child: Container(
        color: PicpleColors.white,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundImage: state.profileImage != null
                            ? NetworkImage(state.profileImage!)
                            : const AssetImage('assets/images/img_profile_placeholder.png') as ImageProvider,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.nickname ?? '닉네임 없음',
                        style: PicpleTypography.title2,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: PicpleColors.gray2)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: PicpleColors.primary1,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: PicpleColors.primary1,
                      width: 2,
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: PicpleColors.primary1,
                  unselectedLabelColor: PicpleColors.gray5,
                  labelStyle: PicpleTypography.body1SemiBold,
                  tabs: const [Tab(text: '내가 찍은 사진'), Tab(text: '좋아요한 사진')],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildPhotoGrid(state.myPhotos), _buildPhotoGrid(state.myLikedPhotos)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<SimplePhotoData> photos) {
    return GridView.builder(
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
