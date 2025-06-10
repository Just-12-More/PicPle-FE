import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';
import 'package:picple/routes.dart';

import '../provider/setting_contract.dart';
import '../provider/setting_notifier.dart';


class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(settingStateProvider.notifier);

    ref.listen<SettingEffect?>(settingEffectProvider, (previous, next) {
      if (next == null) return;
      switch (next) {
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
        case BackToLogin():
          context.go(Routes.login.path);
          break;
      }
      ref.read(settingEffectProvider.notifier).state = null;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '설정',
          style: PicpleTypography.title1,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: PicpleColors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingItem(
              icon: Icons.person_outline,
              label: '프로필 수정',
              onTap: () => notifier.navigateTo("${Routes.profile.path}/${Routes.profileEdit.path}"),
            ),
            _SettingItem(
              icon: Icons.description_outlined,
              label: '서비스 이용약관',
              onTap: () {},
            ),
            _SettingItem(
              icon: Icons.location_on_outlined,
              label: '위치정보 이용약관',
              onTap: () {},
            ),
            _SettingItem(
              icon: Icons.assignment_outlined,
              label: '개인정보 처리방침',
              onTap: () {},
            ),
            _SettingItem(
              icon: Icons.logout,
              label: '로그아웃',
              onTap: () => notifier.logout(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: PicpleColors.gray5, size: 24),
                  SizedBox(width: 16),
                  Text(
                    '버전 정보',
                    style: PicpleTypography.body1,
                  ),
                  Spacer(),
                  Text(
                    'v1.0.0',
                    style: PicpleTypography.body1,
                  ),
                ],
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => notifier.withdraw(),
                child: const Text(
                  '탈퇴하기',
                  style: TextStyle(
                    color: PicpleColors.gray5,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PicpleColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: PicpleColors.gray5, size: 24),
              const SizedBox(width: 16),
              Text(
                label,
                style: PicpleTypography.body1.copyWith(
                  color: PicpleColors.black,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: PicpleColors.gray5),
            ],
          ),
        ),
      ),
    );
  }
}
