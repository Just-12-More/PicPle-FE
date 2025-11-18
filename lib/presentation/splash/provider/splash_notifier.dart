import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/service_providers.dart';
import 'package:picple/presentation/splash/provider/splash_contract.dart';

import '../../../data/api/storage_api.dart';
import '../../../routes.dart';

final splashStateProvider = NotifierProvider.autoDispose<SplashNotifier, SplashState>(() => SplashNotifier());
final splashEffectProvider = StateProvider.autoDispose<SplashEffect?>((ref) => null);

class SplashNotifier extends AutoDisposeNotifier<SplashState> {
  late final StorageApi _storageApi;

  @override
  SplashState build() {
    _storageApi = ref.watch(storageApiProvider);
    Future.delayed(const Duration(seconds: 1), checkLogin);
    return SplashState();
  }

  void checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await _storageApi.getAccessToken() ?? '';
    if (accessToken.isNotEmpty) {
      _navigateTo(Routes.home.path);
    } else {
      _navigateTo(Routes.login.path);
    }
  }

  void _navigateTo(String route) {
    ref.read(splashEffectProvider.notifier).state = NavigateTo(route);
  }
}
