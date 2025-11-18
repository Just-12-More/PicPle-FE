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
        alignment: Alignment.center,
        children: [
          BottomAppBar(
            padding: EdgeInsets.zero,
            color: PicpleColors.white,
            height: 76,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  iconPath: 'assets/icons/ic_home.svg',
                  label: '홈',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),

                _buildNavItem(
                  iconPath: 'assets/icons/ic_map.svg',
                  label: '지도',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),

                _buildNavItem(
                  iconPath: 'assets/icons/ic_upload.svg',
                  label: '업로드',
                  isSelected: false,
                  onTap: onUploadTap
                ),

                _buildNavItem(
                  iconPath: 'assets/icons/ic_profile.svg',
                  label: '프로필',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    double leftPadding = 0.0,
    double rightPadding = 0.0,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
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
        ),
      ),
    );
  }
}