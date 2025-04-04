import '../../../core/base/base_controller.dart';

class LoginState implements UiState {
  final bool isLoading;

  LoginState({this.isLoading = false});

  LoginState copyWith({bool? isLoading, String? lastLoginMethod}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class LoginEvent implements UiEvent {}
class KakaoLoginButtonClicked extends LoginEvent {}
class GoogleLoginButtonClicked extends LoginEvent {}

abstract class LoginEffect implements UiEffect {}
class NavigateTo extends LoginEffect {
  final String route;
  NavigateTo(this.route);
}
class ShowToast extends LoginEffect {
  final String message;
  ShowToast(this.message);
}
