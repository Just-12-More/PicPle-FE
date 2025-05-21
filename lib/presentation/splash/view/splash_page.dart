import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/splash/controller/splash_contract.dart';
import 'package:picple/presentation/splash/controller/splash_notifier.dart';

import '../../theme/picple_colors.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashStateProvider.notifier).checkLogin();
    });

    ref.listen<SplashEffect?>(splashEffectProvider, (previous, next) {
      if (next == null) return;

      if (next is NavigateTo) {
        context.go(next.route);
      }

      ref.read(splashEffectProvider.notifier).state = null;
    });

    return Material(
      color: PicpleColors.white,
      child: SafeArea(
        child: Center(
          child: Image.asset('assets/icons/ic_picple.png'),
        ),
      ),
    );
  }
}
