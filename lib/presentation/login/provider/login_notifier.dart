import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../../data/service_providers.dart';
import '../../../data/services/auth_service.dart';
import '../../../models/auth/login_request.dart';
import 'login_contract.dart';

final loginStateProvider = NotifierProvider<LoginNotifier, LoginState>(() => LoginNotifier());
final loginEffectProvider = StateProvider<LoginEffect?>((ref) => null);

class LoginNotifier extends Notifier<LoginState> {
  late final AuthService _authService;

  @override
  LoginState build() {
    _authService = ref.watch(authServiceProvider);
    return LoginState();
  }

  Future<void> loginWithKakao() async {
    state = state.copyWith(isLoading: true);

    try {
      if (await isKakaoTalkInstalled()) {
        final token = await UserApi.instance.loginWithKakaoTalk();
        final request = LoginRequest(
          accessToken: token.accessToken,
          provider: LoginProvider.kakao,
        );

        final result = await _authService.login(request);

        if (result.isSuccess) {
          _showToast("로그인 성공");
          _navigateTo("/home");
        } else {
          _showToast("로그인 실패");
        }
      } else {
        _showToast("카카오톡 미설치");
      }
    } catch (e) {
      _showToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _navigateTo(String route) {
    ref.read(loginEffectProvider.notifier).state = NavigateTo(route);
  }

  void _showToast(String message) {
    ref.read(loginEffectProvider.notifier).state = ShowToast(message);
  }
}