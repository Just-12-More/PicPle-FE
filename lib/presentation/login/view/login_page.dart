import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/presentation/login/controller/login_controller.dart';

import '../../../core/base/base_controller.dart';
import '../controller/login_contract.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginController);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display loading indicator or login buttons
            state.isLoading
                ? const CircularProgressIndicator()
                : LoginButtons(
                    onProcessEvent: (event) {
                      ref.read(loginController.notifier).onEventReceived(event);
                    },
                  ),
            const SizedBox(height: 20),
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
          label: 'Login with Kakao',
        ),
        LoginButton(
          onPressed: () {
            onProcessEvent(GoogleLoginButtonClicked());
          },
          label: 'Login with Google',
        ),
      ],
    );
  }
}

// Reusable login button widget
class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const LoginButton({required this.onPressed, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
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
      Navigator.pushNamed(context, route);
    });
  }
}