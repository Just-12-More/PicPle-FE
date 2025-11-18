import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/login/provider/login_contract.dart';
import 'package:picple/presentation/login/provider/login_notifier.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/theme/picple_typography.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      loginStateProvider.select((state) => state.isLoading),
    );

    ref.listen<LoginEffect?>(loginEffectProvider, (previous, next) {
      if (next == null) return;

      switch (next) {
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
        case NavigateTo():
          context.go(next.route);
          break;
      }

      ref.read(loginEffectProvider.notifier).state = null;
    });

    return Scaffold(
      backgroundColor: PicpleColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Image.asset(
                'assets/icons/ic_picple.png',
                width: 300,
                height: 200,
              ),
              const Expanded(child: SizedBox()),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? const SizedBox(
                        key: ValueKey('login_loading'),
                        height: 48,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : LoginButtons(
                        key: const ValueKey('login_buttons'),
                        onPressed: () {
                          ref
                              .read(loginStateProvider.notifier)
                              .loginWithKakao();
                        },
                      ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF808080),
                  ),
                  children: [
                    TextSpan(text: '첫 로그인 시, '),
                    TextSpan(
                      text: '서비스 이용약관',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: PicpleColors.gray5,
                      ),
                    ),
                    TextSpan(text: '에 동의한 것으로 간주합니다.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButtons extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButtons({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          LoginButton(
            onPressed: onPressed,
            label: '카카오로 3초만에 시작하기',
            iconPath: 'assets/icons/ic_kakao.svg',
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String? iconPath;

  const LoginButton({
    required this.onPressed,
    required this.label,
    this.iconPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: const Color(0xFFFBE400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          if (iconPath != null) ...[
            SvgPicture.asset(iconPath!, height: 20, width: 22),
          ],
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: PicpleTypography.body1SemiBold.copyWith(
                color: const Color(0xFF3E1A1D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
