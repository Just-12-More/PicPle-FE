import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/presentation/shared/provider/photo_list_contract.dart';
import 'package:picple/presentation/shared/provider/photo_list_provider.dart';

import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';

class PhotoListPage extends StatelessWidget {
  const PhotoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PhotoListScreen();
  }
}

class PhotoListScreen extends ConsumerWidget {
  const PhotoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(photoListStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(photoListStateProvider.notifier).fetchPhotoList();
    });

    ref.listen<PhotoListEffect?>(photoListEffectProvider, (previous, next) {
      if (next == null) return;

      if (next is ShowToast) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }

      ref.read(photoListEffectProvider.notifier).state = null;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(state.address, style: PicpleTypography.title1),
        centerTitle: true,
      ),
      backgroundColor: PicpleColors.background,
      body: SafeArea(
        child: ListView.builder(
          itemCount: state.photos.length,
          itemBuilder: (context, index) {
            final photo = state.photos[index];

            return FeedItem(
              username: photo.nickname,
              profileImageUrl: photo.profileImgUrl,
              imageUrl: photo.imgUrl,
              isLiked: photo.isLiked,
              likeCount: photo.likeCount,
              title: photo.title,
              description: photo.description,
              time: photo.formattedTime,
            );
          },
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
                    color: isLiked ? PicpleColors.red : PicpleColors.gray5,
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
