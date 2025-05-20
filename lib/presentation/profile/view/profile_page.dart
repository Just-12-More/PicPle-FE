import 'package:flutter/material.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('마이페이지', style: PicpleTypography.title1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: PicpleColors.white,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/men/10.jpg',
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('핵귀요미 준서', style: PicpleTypography.title2),
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
                  children: [_buildPhotoGrid(), _buildPhotoGrid()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    final List<String> images = List.generate(
      12,
      (index) =>
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
    );
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return Image.network(images[index], fit: BoxFit.cover);
      },
    );
  }
}
