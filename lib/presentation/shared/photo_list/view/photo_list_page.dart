import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/picple_colors.dart';
import '../../../theme/picple_typography.dart';
import '../../component/feed_item.dart';
import '../provider/photo_list_contract.dart';
import '../provider/photo_list_provider.dart';

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
        scrolledUnderElevation: 0,
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

