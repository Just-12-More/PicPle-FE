import 'package:flutter/material.dart';

import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';

class PhotoListPage extends StatelessWidget {
  const PhotoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PhotoListScreen();
  }
}

class PhotoListScreen extends StatefulWidget {
  const PhotoListScreen({super.key});

  @override
  State<PhotoListScreen> createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  final dummyFeeds = List.generate(10, (index) => FeedItem(
    username: '준서 핵졸귀',
    profileImageUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
    imageUrl: 'https://picsum.photos/id/${index + 10}/400/300',
    isLiked: index % 2 == 0,
    likeCount: 5 + index,
    title: '낭만 넘치는 이곳',
    description: '와 여기 경치가 되게 좋네요~~~~',
    time: '2시간 전',
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('서울시 행궁동', style: PicpleTypography.title1),
        centerTitle: true,
      ),
      backgroundColor: PicpleColors.background,
      body: SafeArea(
        child: ListView.builder(
          itemCount: dummyFeeds.length,
          itemBuilder: (context, index) => dummyFeeds[index],
        ),
      ),
    );
  }
}

class FeedItem extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final String imageUrl;
  final bool isLiked;
  final int likeCount;
  final String title;
  final String description;
  final String time;

  const FeedItem({
    super.key,
    required this.username,
    required this.profileImageUrl,
    required this.imageUrl,
    required this.isLiked,
    required this.likeCount,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 유저 정보
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(profileImageUrl), // 유저 이미지
              ),
              const SizedBox(width: 8),
              Text(
                  username,
                  style: PicpleTypography.body1SemiBold.copyWith(color: PicpleColors.black)
              ),
            ],
          ),
        ),

        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$likeCount',
                    style: PicpleTypography.body1.copyWith(color: PicpleColors.black)
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                  title,
                  style: PicpleTypography.title2.copyWith(color: PicpleColors.black)
              ),
              const SizedBox(height: 8),
              Text(
                  description,
                  style: PicpleTypography.body2.copyWith(color: PicpleColors.black)
              ),
              const SizedBox(height: 4),
              Text(
                  time,
                  style: PicpleTypography.nav.copyWith(color: PicpleColors.gray5)
              ),
            ],
          ),
        ),
      ],
    );
  }
}
