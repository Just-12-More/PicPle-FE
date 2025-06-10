import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:picple/data/repository/auth_repository.dart';
import 'package:picple/data/service_providers.dart';

import 'setting_contract.dart';

final settingStateProvider = NotifierProvider<SettingNotifier, SettingState>(() => SettingNotifier());
final settingEffectProvider = StateProvider<SettingEffect?>((ref) => null);

class SettingNotifier extends Notifier<SettingState> {
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

  void logout() {
    _authRepository.logout();
    UserApi.instance.logout();
    navigateBackToLogin();
    _showToast("로그아웃되었습니다.");
  }

  void withdraw() {
    _authRepository.withdrawal();
    UserApi.instance.logout();
    navigateBackToLogin();
    _showToast("탈퇴가 완료되었습니다.");
  }

  void _showToast(String message) {
    ref.read(settingEffectProvider.notifier).state = ShowToast(message);
  }

}