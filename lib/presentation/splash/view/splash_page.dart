import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/core/base/base_controller.dart';
import 'package:picple/presentation/splash/controller/splash_contract.dart';
import 'package:picple/presentation/splash/controller/splash_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref.read(splashController.notifier).onEventReceived(CheckLoginEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Splash Page2'), EffectStreamHandler()],
        ),
      ),
    );
  }
}

class EffectStreamHandler extends ConsumerWidget {
  const EffectStreamHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectManager = ref.watch(splashController.notifier).effectManager;

    return StreamBuilder<UiEffect>(
      stream: effectManager.effectStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final effect = snapshot.data!;
          if (effect is NavigateTo) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(effect.route);
            });
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
