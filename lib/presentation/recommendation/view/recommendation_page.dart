import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routes.dart';
import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';
import '../model/recommendation_photo.dart';
import '../provider/recommendation_provider.dart';

class RecommendationPage extends ConsumerStatefulWidget {
  final List<int> tagIds;
  final VoidCallback? onClose;

  const RecommendationPage({
    super.key,
    this.tagIds = const <int>[],
    this.onClose,
  });

  @override
  ConsumerState<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends ConsumerState<RecommendationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recommendationStateProvider.notifier)
          .fetchRecommendations(widget.tagIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RecommendationEffect?>(recommendationEffectProvider, (
      previous,
      effect,
    ) {
      if (effect is RecommendationShowSnackBar) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(effect.message)));
        ref.read(recommendationEffectProvider.notifier).state = null;
      }
    });

    final state = ref.watch(recommendationStateProvider);

    return Scaffold(
      backgroundColor: PicpleColors.white,
      body: Column(
        children: [
          const SizedBox(height: 160),
          _buildCenterContent(),
          const SizedBox(height: 60),
          Expanded(
            child: _RecommendationPhotoSection(
              photos: state.photos,
              isLoading: state.isLoading,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ElevatedButton(
            onPressed: widget.onClose ?? () => Navigator.of(context).maybePop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: PicpleColors.primary1,
              disabledBackgroundColor: PicpleColors.gray4,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '닫기',
              style: PicpleTypography.body1SemiBold.copyWith(
                color: PicpleColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: PicpleColors.secondary2,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            color: PicpleColors.primary1,
            size: 64,
          ),
        ),
        const SizedBox(height: 20),
        Text('사진이 정상적으로 업로드되었어요!', style: PicpleTypography.title1),
        const SizedBox(height: 8),
        Text(
          '올리신 사진과 비슷한 사진들을 모아봤어요.',
          style: PicpleTypography.body2.copyWith(color: PicpleColors.gray5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _RecommendationPhotoSection extends StatelessWidget {
  final List<RecommendationPhoto> photos;
  final bool isLoading;

  const _RecommendationPhotoSection({
    required this.photos,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text('# 오늘의 추천 사진', style: PicpleTypography.title2),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : photos.isEmpty
            ? Center(
                child: Text(
                  '추천할 사진이 아직 없어요.',
                  style: PicpleTypography.body2.copyWith(
                    color: PicpleColors.gray5,
                  ),
                ),
              )
            : SizedBox(
                height: 108,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('${Routes.photoDetail.path}/${photo.id}');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: photo.imageUrl,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/img_placeholder.png',
                            width: 108,
                            height: 108,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/img_placeholder.png',
                            width: 108,
                            height: 108,
                            fit: BoxFit.cover,
                          ),
                          width: 108,
                          height: 108,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
