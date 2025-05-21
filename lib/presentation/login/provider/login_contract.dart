class LoginState {
  final bool isLoading;

  LoginState({this.isLoading = false});

  LoginState copyWith({bool? isLoading, String? lastLoginMethod}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class LoginEffect { }
class NavigateTo extends LoginEffect {
  final String route;
  NavigateTo(this.route);
}
class ShowToast extends LoginEffect {
  final String message;
  ShowToast(this.message);
}
