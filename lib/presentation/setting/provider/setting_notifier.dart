import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:picple/data/repository/auth_repository.dart';
import 'package:picple/data/service_providers.dart';

import 'setting_contract.dart';

final settingStateProvider = NotifierProvider.autoDispose<SettingNotifier, SettingState>(() => SettingNotifier());
final settingEffectProvider = StateProvider.autoDispose<SettingEffect?>((ref) => null);

class SettingNotifier extends AutoDisposeNotifier<SettingState> {
  late final AuthRepository _authRepository;

  @override
  SettingState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return SettingState();
  }

  void navigateBackToLogin() {
    ref.read(settingEffectProvider.notifier).state = BackToLogin();
  }

  void navigateTo(String route) {
    ref.read(settingEffectProvider.notifier).state = NavigateTo(route);
  }

  Future<void> logout() async {
    await _runAsyncAction(
      action: () async {
        await _authRepository.logout();
        await UserApi.instance.unlink();
      },
      onSuccess: () {
        navigateBackToLogin();
        _showToast("로그아웃되었습니다.");
      },
    );
  }

  Future<void> withdraw() async {
    await _runAsyncAction(
      action: () async {
        await _authRepository.withdrawal();
        await UserApi.instance.unlink();
      },
      onSuccess: () {
        navigateBackToLogin();
        _showToast("탈퇴가 완료되었습니다.");
      },
    );
  }

  Future<void> _runAsyncAction({
    required Future<void> Function() action,
    required VoidCallback onSuccess,
  }) async {
    state = state.copyWith(isProcessing: true);
    try {
      await action();
      onSuccess();
    } catch (e) {
      _showToast("오류가 발생했습니다: $e");
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  void _showToast(String message) {
    ref.read(settingEffectProvider.notifier).state = ShowToast(message);
  }

}
