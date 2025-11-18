import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/picple_colors.dart';
import '../provider/splash_contract.dart';
import '../provider/splash_notifier.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(splashStateProvider.notifier).checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
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
