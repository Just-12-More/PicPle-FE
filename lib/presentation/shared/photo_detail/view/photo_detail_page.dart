import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/presentation/shared/photo_detail/provider/photo_detail_provider.dart';

import '../../../theme/picple_colors.dart';
import '../../../theme/picple_typography.dart';
import '../../component/feed_item.dart';


class PhotoDetailPage extends StatelessWidget {
  final int photoId;

  const PhotoDetailPage({super.key, required this.photoId});

  @override
  Widget build(BuildContext context) {
    return PhotoDetailScreen(photoId: photoId);
  }
}

class PhotoDetailScreen extends ConsumerWidget {
  final int photoId;

  const PhotoDetailScreen({super.key, required this.photoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(photoDetailStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(photoDetailStateProvider.notifier).fetchPhotoDetail(photoId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(state.photo.address, style: PicpleTypography.title1),
        centerTitle: true,
      ),
      backgroundColor: PicpleColors.background,
      body: SafeArea(
        child: !state.isInitialized
            ? const Center(
              child: CircularProgressIndicator(),
            )
          : FeedItem(
              username: state.photo.nickname,
              profileImageUrl: state.photo.profileImgUrl,
              imageUrl: state.photo.imgUrl,
              isLiked: state.photo.isLiked,
              likeCount: state.photo.likeCount,
              title: state.photo.title,
              description: state.photo.description,
              time: state.photo.formattedTime,
              onToggleLike: () => ref.read(photoDetailStateProvider.notifier).toggleLikePhoto(photoId),
            ),
      ),
    );
  }
}