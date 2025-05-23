import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

class PicpleBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onUploadTap;

  const PicpleBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomAppBar(
            color: PicpleColors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: SizedBox(
              height: 76,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    iconPath: 'assets/icons/ic_home.svg',
                    label: '홈',
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  const SizedBox(width: 72), // 카메라 버튼 공간 확보
                  _buildNavItem(
                    index: 1,
                    iconPath: 'assets/icons/ic_profile.svg',
                    label: '프로필',
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                ],
              ),
            ),
          ),
      
          // 가운데 카메라 버튼
          Positioned(
            top: 0,
            bottom: 0, // 높이 조정
            child: SizedBox(
              width: 64,
              height: 64,
              child: FloatingActionButton(
                onPressed: onUploadTap,
                backgroundColor: PicpleColors.primary1,
                shape: const CircleBorder(),
                elevation: 0,
                child: SvgPicture.asset(
                  'assets/icons/ic_upload.svg',
                  width: 48,
                  height: 48,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? PicpleColors.primary1 : PicpleColors.gray5,
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
}