import 'package:picple/core/base/base_controller.dart';

class SplashState implements UiState {
  final bool isLoading;

  SplashState({this.isLoading = false});
}

abstract class SplashEvent implements UiEvent {}

class CheckLoginEvent extends SplashEvent {}

abstract class SplashEffect implements UiEffect {}

class NavigateTo extends SplashEffect {
  final String route;
  NavigateTo(this.route);
}
