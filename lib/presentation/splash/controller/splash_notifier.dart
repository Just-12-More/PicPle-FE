import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/presentation/splash/controller/splash_contract.dart';

final splashStateProvider = NotifierProvider<SplashNotifier, SplashState>(() => SplashNotifier());
final splashEffectProvider = StateProvider<SplashEffect?>((ref) => null);

class SplashNotifier extends Notifier<SplashState> {
  @override
  SplashState build() {
    return SplashState();
  }

  void checkLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      if (false) {
        _navigateTo('/home');
      } else {
        _navigateTo('/login');
      }
    });
  }

  void _navigateTo(String route) {
    ref.read(splashEffectProvider.notifier).state = NavigateTo(route);
  }
}