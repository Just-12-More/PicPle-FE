import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/locator.dart';
import 'package:picple/models/auth/login_request.dart';
import 'package:picple/routes.dart';
import 'package:picple/services/auth_service.dart';

import '../../../core/base/base_controller.dart';
import 'login_contract.dart';

class LoginController extends BaseController<LoginState, LoginEvent, LoginEffect> {
  LoginController({
    required EffectManager effectManager,
    required this.authService,
  }) : super(LoginState(), effectManager);
  AuthService authService;

  @override
  void onEventReceived(LoginEvent event) {
    if (event is KakaoLoginButtonClicked) {
      _kakaoLogin();
    } else if (event is GoogleLoginButtonClicked) {
      _googleLogin();
    }
  }

  void _kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
        final authService = locator<AuthService>();
        final request = LoginRequest(accessToken: token.accessToken, provider: LoginProvider.kakao);
        final response = await authService.login(request);

        if (response.isSuccess) {
          showToast("Kakao login successful");
          // goto home page using go router
          navigateTo(Routes.home.path);
        } else {
          showToast("Kakao login failed");
        }
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      showToast("카카오톡이 설치되어 있지 않습니다.");
    }
  }

  void _googleLogin() async {
    updateState(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 2));
    updateState(state.copyWith(isLoading: false));

    showToast("Google login successful");
  }

  void showToast(String message) {
    postEffect(ShowToast(message));
  }

  void navigateTo(String route) {
    postEffect(NavigateTo(route));
  }
}

final loginController = StateNotifierProvider<LoginController, LoginState>((ref) {
  final effectManager = EffectManager();
  final authService = locator<AuthService>();
  return LoginController(effectManager: effectManager, authService: authService);
});