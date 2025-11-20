import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/model/response/tag_response.dart';
import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';

class FeedItem extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final String imageUrl;
  final bool isLiked;
  final List<TagItem> tags;
  final int likeCount;
  final String title;
  final String description;
  final String time;
  final VoidCallback onToggleLike;

  const FeedItem({
    super.key,
    required this.username,
    required this.profileImageUrl,
    required this.imageUrl,
    required this.isLiked,
    required this.tags,
    required this.likeCount,
    required this.title,
    required this.description,
    required this.time,
    required this.onToggleLike,
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
              ClipOval(
                child: CachedNetworkImage(
                  width: 30,
                  height: 30,
                  imageUrl: profileImageUrl,
                  placeholder: (context, url) => Image.asset('assets/images/img_profile_placeholder.png'),
                  errorWidget: (context, url, error) => Image.asset('assets/images/img_profile_placeholder.png'),
                )
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
          child: GestureDetector(
            onDoubleTap: onToggleLike,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  Image.asset('assets/images/img_placeholder.png', fit: BoxFit.cover),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/img_placeholder.png', fit: BoxFit.cover),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onToggleLike,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? PicpleColors.red : PicpleColors.gray5,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$likeCount',
                        style: PicpleTypography.body1.copyWith(color: PicpleColors.black),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(tags.length, (index) {
                            final tag = tags[index];
                            return Padding(
                              padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: PicpleColors.primary1,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  '#${tag.name}',
                                  style: PicpleTypography.body2.copyWith(
                                    color: PicpleColors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
