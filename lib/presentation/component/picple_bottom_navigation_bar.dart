import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

class PicpleBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PicpleBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildNavItem(
      {required int index,
        required String iconPath,
        required String label}) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkResponse(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? PicpleColors.primary1
                    : PicpleColors.gray5,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: PicpleTypography.nav.copyWith(
                color: isSelected ? PicpleColors.primary1 : PicpleColors.gray5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      height: 77,
      shadowColor: Colors.black,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              iconPath: 'assets/icons/ic_home.svg',
              label: '홈',
            ),
            _buildNavItem(
              index: 1,
              iconPath: 'assets/icons/ic_upload.svg',
              label: '사진 업로드',
            ),
            _buildNavItem(
              index: 2,
              iconPath: 'assets/icons/ic_profile.svg',
              label: '프로필',
            ),
          ],
        ),
      ),
    );
  }
}