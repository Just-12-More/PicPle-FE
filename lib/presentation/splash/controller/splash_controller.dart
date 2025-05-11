import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/core/base/base_controller.dart';
import 'package:picple/presentation/splash/controller/splash_contract.dart';

class SplashController
    extends BaseController<SplashState, SplashEvent, SplashEffect> {
  SplashController({required EffectManager effectManager})
    : super(SplashState(), effectManager);

  @override
  void onEventReceived(SplashEvent event) {
    if (event is CheckLoginEvent) {
      _checkLogin();
    }
  }

  void _checkLogin() {
    // check if user is logged in
    if (false) {
      // if logged in, navigate to home page
      _navigateTo('/home');
    } else {
      // if not logged in, navigate to login page
      _navigateTo('/login');
    }
  }

  void _navigateTo(String route) {
    postEffect(NavigateTo(route));
  }
}

final splashController = StateNotifierProvider<SplashController, SplashState>((
  ref,
) {
  final effectManager = EffectManager();
  return SplashController(effectManager: effectManager);
});
