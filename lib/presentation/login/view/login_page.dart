import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/login/controller/login_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/base/base_controller.dart';
import '../controller/login_contract.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginController);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 144),
            Image.asset(
              'assets/icons/ic_picple.png',
              width: 300,
              height: 200,
            ),
            const Expanded(child: SizedBox()),
            state.isLoading
                ? const CircularProgressIndicator()
                : LoginButtons(
                    onProcessEvent: (event) {
                      ref.read(loginController.notifier).onEventReceived(event);
                    },
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
                    ),
                  ),
                  TextSpan(text: '에 동의한 것으로 간주합니다.'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const EffectStreamHandler(),
          ],
        ),
      ),
    );
  }
}

// Reusable button widget
class LoginButtons extends StatelessWidget {
  final Function(LoginEvent) onProcessEvent;

  const LoginButtons({
    required this.onProcessEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginButton(
          onPressed: () {
            onProcessEvent(KakaoLoginButtonClicked());
          },
          label: '카카오로 3초만에 시작하기',
          iconPath: 'assets/icons/ic_kakao.svg',
        ),
      ],
    );
  }
}

// Reusable login button widget
class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String? iconPath;

  const LoginButton({
    required this.onPressed, 
    required this.label, 
    this.iconPath,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFBE400),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              if (iconPath != null) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(
                  iconPath!,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EffectStreamHandler extends ConsumerWidget {
  const EffectStreamHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectManager = ref.watch(loginController.notifier).effectManager;

    return StreamBuilder<UiEffect>(
      stream: effectManager.effectStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final effect = snapshot.data!;
          if (effect is ShowToast) {
            _showToast(context, effect.message);
          } else if (effect is NavigateTo) {
            _navigateTo(context, effect.route);
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showToast(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  void _navigateTo(BuildContext context, String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(route);
    });
  }
}